#!/usr/bin/env -S uv run
# /// script
# requires-python = ">=3.11"
# dependencies = [
#   "typer>=0.12",
# ]
# ///

"""
Build Markdown setup guides from simple, human-readable config files.

This Typer CLI reads one or more config files composed of sections separated by
lines containing only `---`. Each section may contain any of the following keys
(at column 0): `maintitle:`, `title:`, `step:`, `bash:`, `note:`, `item:`.

Output: For each input file, a `.md` file is generated that:
  • Emits `maintitle` as the H1 (`#`) once at the top (if present).
  • Emits each `title` as an H2 (`##`) in order.
  • Preserves the order of `step`, `bash`, `note`, and `item` within a section.
  • Renders `step` as a numbered list item.
  • Renders `bash` as a fenced code block (```bash ... ```), supporting multi-line commands.
  • Renders `note` as a blockquote (`> ...`).
  • Renders `item` as a bullet (`- ...`).
  • Strips <mark>…</mark> tags from the maintitle and section titles only.

File naming:
  • By default, outputs next to the input: `<input-stem>.md`.
  • With `--out-dir`, writes into the specified directory.
  • With `--name-from-title`, uses a slugified `maintitle` for the filename.
  • Refuses to overwrite unless `--force` is provided.

Assumptions & parsing rules:
  • Keys must start at column 0; indented keys are ignored.
  • Unknown keys are ignored.
  • Empty lines are allowed; they are not emitted.
  • A `bash:` key gathers following lines until the next recognized key or EOF.
  • Only the first block may define `maintitle:`; later `maintitle:` entries are ignored.
  • `<mark>…</mark>` is removed from headings but left intact elsewhere.

Examples
--------
Input config:

    maintitle: Linux (Debian) Setup

    ---
    title: Update System
    step: go to terminal and run this
    bash:
    sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove

Command:

    uv run build_guides.py debian.txt -o out --name-from-title

Emitted Markdown (out/linux-debian-setup.md):

    # Linux (Debian) Setup
    ---
    ## Update System

    1. go to terminal and run this

    ```bash
    sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove
    ```

CLI
---
build [OPTIONS] CONFIGS...

Options:
  -o, --out-dir PATH        Output directory for .md files.
  -f, --force               Overwrite existing files.
      --name-from-title     Name output from the maintitle (slugified).
      --stdout              Print result to stdout (only with a single input).
  -h, --help                Show this message and exit.
"""


from __future__ import annotations

import re
from pathlib import Path
from typing import List, Tuple, Optional
import typer

app = typer.Typer(help="Build Markdown setup guides from simple config files.")

SECTION_SPLIT_RE = re.compile(r"^\s*---\s*$", re.MULTILINE)
KEY_RE = re.compile(r"^(maintitle|title|step|bash|note|item|download):\s*(.*)$", re.IGNORECASE)
MARK_TAG_RE = re.compile(r"</?mark>", re.IGNORECASE)


def strip_mark_tags(text: str) -> str:
    return MARK_TAG_RE.sub("", text).strip()


def slugify(text: str) -> str:
    text = strip_mark_tags(text)
    text = text.strip().lower()
    # keep ascii letters/numbers, replace spaces with '-', keep [] for flavor, drop other punctuation
    text = re.sub(r"\s+", "-", text)
    text = re.sub(r"[^a-z0-9\-\[\]]+", "", text)
    text = re.sub(r"-{2,}", "-", text).strip("-")
    return text or "output"


def _parse_block(block: str) -> Tuple[Optional[str], List[Tuple[str, str]]]:
    """
    Returns (title, events) where events is an ordered list of (key, value).
    Keys are one of: step, bash, note, item. Title may be None.
    """
    lines = [ln.rstrip() for ln in block.splitlines() if ln.strip() != ""]
    idx = 0
    title: Optional[str] = None
    events: List[Tuple[str, str]] = []

    def is_key(line: str) -> Optional[Tuple[str, str]]:
        m = KEY_RE.match(line)
        if not m:
            return None
        return m.group(1).lower(), m.group(2)

    while idx < len(lines):
        probe = is_key(lines[idx])
        if not probe:
            # Ignore stray text lines (keeps format simple).
            idx += 1
            continue

        key, rest = probe
        if key == "title":
            title = rest.strip()
            idx += 1
            continue

        if key == "bash":
            # Capture a multi-line bash block until the next key or end.
            buf: List[str] = []
            if rest:
                buf.append(rest)
                idx += 1
            else:
                idx += 1
            while idx < len(lines):
                maybe = is_key(lines[idx])
                if maybe:
                    break
                buf.append(lines[idx])
                idx += 1
            value = "\n".join(buf).strip()
            if value:
                events.append(("bash", value))
            continue

        # Single-line keys: step, note, item, (maintitle allowed but ignored here)
        if key in {"step", "note", "item", "download"}:
            events.append((key, rest.strip()))
        # maintitle in a section is ignored
        idx += 1

    return title, events


def parse_config(text: str) -> Tuple[Optional[str], List[Tuple[str, List[Tuple[str, str]]]]]:
    """
    Returns (maintitle, sections) where sections is a list of (title, events).
    """
    parts = [p.strip() for p in SECTION_SPLIT_RE.split(text) if p.strip()]
    maintitle: Optional[str] = None
    sections: List[Tuple[str, List[Tuple[str, str]]]] = []

    if parts:
        # If the very first part is only a maintitle, peel it off.
        first_title, first_events = _parse_block(parts[0])
        # Look for explicit maintitle in the first block
        mt = None
        for ln in parts[0].splitlines():
            m = KEY_RE.match(ln)
            if m and m.group(1).lower() == "maintitle":
                mt = m.group(2).strip()
                break
        if mt:
            maintitle = mt
            parts = parts[1:]
        else:
            # If no explicit maintitle, the first block is just a section
            if first_title or first_events:
                sections.append((first_title or "Section", first_events))
            parts = parts[1:]

    for part in parts:
        title, events = _parse_block(part)
        sections.append((title or "Section", events))

    return maintitle, sections


def render_markdown(maintitle: Optional[str], sections) -> str:
    out: List[str] = []
    if maintitle:
        out.append(f"# {strip_mark_tags(maintitle)}")
        out.append("---")
        out.append("")

    for (title, events) in sections:
        out.append(f"## {strip_mark_tags(title)}")
        out.append("")
        step_no = 0
        for key, val in events:
            if key == "note":
                out.append(f"> {val}")
                out.append("")
            elif key == "step":
                step_no += 1
                out.append(f"{step_no}. {val}")
                out.append("")
            elif key == "item":
                out.append(f"- {val}")
            elif key == "bash":
                out.append("```bash")
                out.append(val)
                out.append("```")
                out.append("")
            elif key == "download":
                href = val
                filename = Path(href).name
                out.append(f'<a href="{href}" download="{filename}">Download as {filename}</a>')
                out.append("")

        # ensure a blank line between sections
        if out and out[-1] != "":
            out.append("")

    # Tidy trailing whitespace/newlines
    while out and out[-1] == "":
        out.pop()
    out.append("")  # single newline at EOF
    return "\n".join(out)


def default_output_path(
    input_path: Path,
    maintitle: Optional[str],
    out_dir: Optional[Path],
    name_from_title: bool,
) -> Path:
    if out_dir is None:
        base = input_path.stem
        if name_from_title and maintitle:
            base = slugify(maintitle)
        return input_path.with_name(f"{base}.md")
    else:
        out_dir.mkdir(parents=True, exist_ok=True)
        base = input_path.stem
        if name_from_title and maintitle:
            base = slugify(maintitle)
        return out_dir / f"{base}.md"


@app.command()
def build(
    configs: List[Path] = typer.Argument(..., exists=True, readable=True, help="Input config file(s)."),
    out_dir: Optional[Path] = typer.Option(None, "--out-dir", "-o", help="Directory for output .md files."),
    overwrite: bool = typer.Option(False, "--force", "-f", help="Overwrite existing output files."),
    name_from_title: bool = typer.Option(False, "--name-from-title", help="Name output file from maintitle."),
    stdout: bool = typer.Option(False, "--stdout", help="Print result to stdout (only valid with one input)."),
):
    """
    Convert one or more config files into Markdown guides.

    Example:
      python build_guides.py setup_debian.txt setup_mint.txt -o out/ --name-from-title
    """
    if stdout and len(configs) != 1:
        raise typer.BadParameter("--stdout is only valid when a single input file is provided.")

    for cfg in configs:
        text = cfg.read_text(encoding="utf-8")
        maintitle, sections = parse_config(text)
        md = render_markdown(maintitle, sections)

        if stdout:
            typer.echo(md)
            continue

        out_path = default_output_path(cfg, maintitle, out_dir, name_from_title)
        if out_path.exists() and not overwrite:
            raise typer.BadParameter(f"Refusing to overwrite existing file: {out_path} (use --force)")

        out_path.write_text(md, encoding="utf-8")
        typer.echo(f"Successfully Wrote {out_path}")


if __name__ == "__main__":
    app()
