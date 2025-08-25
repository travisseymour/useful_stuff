# My MARP FAQ

- [What is Marp?](#what-is-marp)
- [How do you install Marp?](#installing-marp)
- [My Marp Workflow](#marp-cli-workflow)
- [What is Marp2PDF?](#what-is-marp-to-pdf)
- [Header Slides](#header-slides)
- [Images](#images)
- [Videos](#videos)
- [Putting Content Into Columns](#columnate-content)
- [Linking Slides](#slide-links)
- [Override Presentation Defaults](#override-presentation-defaults)
- [Override Slide Defaults](#override-slide-defaults)
- [Fit Text To Slide Width](#fit-text-width)
- [Change Word or Phrase Color](#styling-color)
- [Change Word or Phrase Size](#styling-font)
- [Using Mermaid Diagrams With Marp](#mermaid-marp)
- [Using Plotly Graphs With Marp](#plotly-marp)
- [Useful Websites](#useful-websites)

---

# what-is-marp

| Marp (also known as the Markdown Presentation Ecosystem) provides an intuitive experience for creating beautiful slide decks. You only have to focus on writing your story in a Markdown document.

I use Marp instead of Powerpoint to create presenations I use in lectures, talks, and tutorials. If you're a coder or otherwise comfortable with creating documents with plaintext (especially Markdown), then this might be for you. However, for most people, using PowerPoint or some other presenetaiton software package will be faaar easier! An easy way to get started is to use Marp via [VSCode](https://code.visualstudio.com/) or [VSCodium](https://vscodium.com/), but I use Marp CLI with [PyCharm](https://www.jetbrains.com/pycharm/).

Quick Overview Video: [https://www.youtube.com/watch?v=EzQ-p41wNEE](https://www.youtube.com/watch?v=EzQ-p41wNEE)
More about Marp Here: [https://marp.app/](https://marp.app/)
Quick video

---

# installing-marp

## Basic Setup

If you want to use Marp with [VSCode](https://code.visualstudio.com/) or [VSCodium](https://vscodium.com/), you can find it in the normal VSCode marketplace, e.g.:

[Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)

If you want to use Marp with another editor or IDE (I use [PyCharm](https://www.jetbrains.com/pycharm/) becasue I already use it frequently for Python development, otherwise I'd probably use [VSCodium](https://vscodium.com/). This means that I use use Marp-CLI (i.e., the commandline interface). You can learn more more here:

[Marp-CLI](https://github.com/marp-team/marp-cli)

By far the easiest way to install Marp is to use one of the standalone binaries from the marp-cli [Releases Page].

I recommend putting the resulting Marp executable somewhere in your system Path. 

NOTE that if you instead use pip or npx to install Marp, it may already be on your path. Use the [Marp-CLI](https://github.com/marp-team/marp-cli) instructions for info on how to get to the point where you can run Marp from anywhere on your system.

## Setup Chrome Browser for Rendering

The Marp-CLI page discusses how to make sure you have chrome setup for rendering. On [Ubuntu Linux](https://ubuntu.com/download/desktop) (actually, I use [Pop!_OS](https://pop.system76.com/), an OS by system76 based on Ubuntu), I used these instructions:

```bash
sudo add-apt-repository ppa:savoury1/chromium
sudo apt update
sudo apt install chromium-browser
export CHROME_PATH=/usr/bin/chromium-browser
```

---

# marp-cli-workflow

## Setup

### For each new slideshow:

- create a new folder to hold the slideshow
- create 2 subfloders, "images" and "media"
- create a markdown file called "slides.md"
- create a batch file called dev.sh (mac or linux, dev.bat on windows??) and make it executable.
- create a batch file called make_pdf.sh (mak or linux, make_pdf.sh on windows??) and make it executable.

### Boilerplate for the top of slides.md

```markdown
---
marp: true
theme: gaia  # default, uncover, gaia
class: invert   # invert for dark mode of any theme
math: mathjax
footer: ""  /*  @@@@@@@@@@ You could put whatever text you want at the bottom of each slide  @@@@@@@@@@@ */
html: true
size: 4:3 # 16:9 4:3 etc.
style: |
  .two_columns {
    display: grid;
    grid-template-columns: repeat(2, minmax(0, 1fr));
    gap: 1rem;
  }

  .two_columns_60_40 {
    display: grid;
    grid-template-columns: 60% 40%;
    gap: 1rem;
  }

  .two_columns_70_30 {
    display: grid;
    grid-template-columns: 70% 30%;
    gap: 1rem;
  }

  .three_columns {
    display: grid;
    grid-template-columns: repeat(3, minmax(0, 1fr));
    gap: 1rem;
  }

  /* 
  make sure there are spaces above and below the content, e.g.:
  <div class="centerit">
  
  [w:480px]('./images/my_image.png')
  
  </div>
  */
  .centerit {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100vh;
  }
  
  /* small font bulleted list */
  .small_list ul {
    font-size: 22px;
  }

  /* Watermark (after=off, before=on)*/
  section::after {
    position: absolute;
    display: flex;
  
    /* Copyright text */
    content: ".";  /*  @@@@@@@@@@ You could put copyright info here, or use image below  @@@@@@@@@@@ */
    font-size: 20px;
    color: #C0C0C0;
    padding-left: 1980px;
    align-items: center;
  
    /* Position and size */
    left: 30px;
    bottom: 200px;
    height: 350px;
  
    /* Watermark image no-repeat or repeat */
    /* THIS WILL ONLY SHOW UP IF YOU SET "section::before" above. to disble, use "section::after" */
    background: url("./images/watermark2.png") repeat;   /*  @@@@@@@@@@ I have my copyright info in this watermark image  @@@@@@@@@@@ */
    opacity: 0.4;
  
    /* Allow to control elements under the wa termark */
    pointer-events: none;
  }
---
```

### Contents of dev.sh

NOTE: This may need to be adjusted for Windows.
NOTE: This may need to be adjusted on Macos if you are not using bash.

```bash
#!/bin/bash
marp -w -p --html slides.md
```


### Contents of make_pdf.sh

NOTE: This may need to be adjusted for Windows.
NOTE: This may need to be adjusted on Macos if you are not using bash.

```bash
#!/bin/bash
export CHROME_PATH=/usr/bin/chromium-browser
marp --pdf --html --output=. --input-dir=. --allow-local-files
# marp2pdf
```

### Development Workflow

NOTE: the command in `dev.sh` will automatically re-create slides.html from your `slides.md` file (that's what the `-w` flag does). It will also render the current slideshow in a little window so you can see what you are doing (that's what the `-p` flag does). Here is my workflow:

- run `./dev.sh`
- Make a change to slides.md
- Whenever I want to see what I've done in the preview window, I save the file (or enable auto-save for continous updates)
- If I want to see a full-size version in a webbrowser, I drag slides.html to my webbrowser (I use [Firefox](https://www.mozilla.org/en-US/firefox/new/)), but I have to refresh to see any subsequent changes (which is why I prefer to use the preview window).
- To include images, I save them to the images folder and then refer to them as something like `./images/imagename.png`
- To include videos, I save them to the media folder then refer to them as something like `./media/videoname.mp4`
- When donw editing, I cancel out of the process running `./dev.sh` (e.g., using CTRL-C).
- To create a PDF, I run `./make_pdf.sh`

That's it. Making changes to  my slides is as easy as editing the text in `slides.md`.

### Using My Presentations

Marp renders your markdown presentation code into a working static HTML presentation. 
Thus, to show your presentation, just drag `slides.html` into your browser!
I do the following:

- Drag `slides.html` into Firefox
- Click the Presenter's View Icon on the right side of the slide navigation bar at the bottom, which creates another webpage showing the presenter's view.
- I keep the presenter's view page on the primary monitor where I can see it and I drag the normal presentation window onto the external monitor so the audiene can see it.
- moving around in presenter's view automatically controls the audience view.
- Note: To show videos, you have to press start/stop/etc. on the normal presentation window.
- When done, just close the slideshow browser tabs and you're done.

---

# what-is-marp-to-pdf

In the [My Marp Workflow](#marp-cli-workflow) section, `the make_pdf.sh` contents has a command called `marp2pdf` that is commented out. What is this? Marp2PDF is a tool I wrote which does the following:

- looks for the file slides.md and makes a temporary copy of it
- edits the copy to remove any image markup that is followed with this text: ` <!-- nopdf -->`
- in the watermark subsection of the style frontmatter, replaces the text `section::after` with `section::before`
- uses Marp-cli to re-render this temp file to `slides_public.pdf`
- uses ghostscript to do a medium-level image compressed version of the content in `slides_public.pdf` and saves it using the same name.

The result is a considerably smaller PDF that has my watermark image repated across it and that omits images I think would be inappropriate for a public copy (e.g., copyrighted images, etc.). All of this occurs without altering either the original `slides.md` or the standard `slides.pdf` generated by Marp.

Marp2PDF assumes the following:

- chromium-browser is installed (e.g., mine is installed at `/usr/bin/chromium-browser`)
- ghostscript is installed (e.g., mine is installed at `/usr/bin/gs`)
- marp-cli is installed (e.g., mine is installed at `/home/[USERNAME]/Applications/marp`)

Why is `marp2pdf` commented out in `make_pdf.sh`?

That's because it's not yet available publically. When it is, I'll adjust the relevant FAQs. For now, you can just use the default PDF Marp produces, or make the changes I indicated above yourself and then regenerate the PDF.

---

# header-slides

I like headers largeish text over a full-slide images:

```markdown
![bg](images/fullslide_background_image.png)  <!-- nopdf -->

# <span style="color:orange"><!--fit-->My Main Title</span>
## <center>My Subtitle If Needed</center>
### <center>For Lectures, I include Course, Quarter and Year</center>
```

---

# images

## Plain markdown image spec:

```markdown
![](./images/myimage.jpg)
```

## With width specified in pixels (height will be auto-computed)

```markdown
![w:800px](./images/myimage.jpg)
```

## Centered

Note: spaces between `div` tags and markdown is crucial!

```markdown
<div class="centerit">

![w:800px](./images/myimage.jpg)

</div>
```

# Absolute positioning

This allows you to place an image anywhere on the slide!
**Make sure you adjust the top, right, width, and height parameters**.

```markdown
<img src="./images/myimage.png" alt="My Image" style="position: absolute; top: 20px; right: 20px; width: 350px; height: auto;" />
```

# Marp Image Filters

These work on bg and regular images

```markdown
![grayscale](./images/my_image.jpg)
![sepia](./images/my_image.jpg)
![blur](./images/my_image.jpg)
![opacity](./images/my_image.jpg)
```

You can combine and parameterize them

```markdown
![brightness:.75 sepia:50%](./images/my_image.jpg)
```

---

# videos

## Play video files on your computer

```markdown
<iframe width="100%" height="100%"
  src="./media/my_video_file.mp4">
</iframe> 
```

## Play youtube videos

```markdown
<iframe width="100%" height="100%"
  src="https://www.youtube.com/embed/EzQ-p41wNEE">
</iframe> 
```

---

# columnate-content

If you want to columnate you content with equal columns, this is the section for you!

## Text on Right, Image on Left

Note: Image size is in inches, you could also use `px` to specify size in pixels.

```markdown
# Two Cols, one pic, one text

- One
- Two
- Three
- Four

![bg right width:4in](images/my_image.jpg)
```

## Text on Left, Image on Right

Two Columns with a 50/50 Split

```markdown
# Two Cols, one pic, one text

- One
- Two
- Three
- Four

![bg left width:4in](images/my_image.jpg)
```

## Text (or whatever) on both sides

Make sure you have a space between the HTML tags and markdown content!

Two Columns with 50/50 Split

```markdown
<div class="two_columns">
<div>

- aa 
- bb
- cc

</div>
<div>

- 1
- 2
- 3

An Image:<br/>
![w:240](./images/my_image.jpg)

</div>
</div>
```

# Three Columns

Three Columns with 33/33/33 Split

<div class="three_columns">
<div>

- aa 
- bb
- cc

</div>
<div>

- a
- b
- c

</div>
<div>

- x
- y
- z

</div>
</div>

# Two Columns, but with Unequal Columns

For a Two-Column 60/40 Split:

```markdown
<div class="two_columns_60_40">
<div>

![](./images/my_image.jpg)

</div>
<div>

- a
- b
- c

</div>
</div>
```

For a Two-Column 70/30 Split:

```markdown
<div class="two_columns_70_30">
<div>

![](./images/my_image.jpg)

</div>
<div>

- a
- b
- c

</div>
</div>
```

For arbritrary Two-Column Splits Using an Image one One Side and Text On Another

```markdown

- The Text I Want On The Right
- More Rightside Text

![bg left:35%](./images/my_image.jpg)

<!--
the text will take up the remaining space!
-->

```

You can also use the bg directive to divy up slide into two unequal columns:

```markdown
![bg left:33%](./images/my_image.jpg)
```

---

# slide-links

```markdown
[Jump to Slide 2](#2)
```

NOTE: You don't have to do anything on slide 2, Marp will automatically make the link for you. Now when you're viewing your slides, you just click the link and you will jump to that slide.

---

# override-slide-defaults

If you want to change the default background and/or foreground for an individual slide, use these directives within a slide:

```markdown
<!--_backgroundColor: black-->
<!--_color: red-->
```

---


# override-presentation-defaults

Put this at the top of the first slide.
This will only change the tags you override. 
I think `:root` changed the default text.

```markdown
<style>
  :root {
    --color-background: #101010;
    --color-foreground: #f9f06b;
  }

  h1 {
    font-family: Courier New;
  }
</style>
```

---

# fit-text-width

If you want to make some text fill up the slide, use this:

```markdown
<!--fit-->Huge Text!!
```

---

# styling-color

```markdown
This is some **bold** text.
This is some <span style="color:yellow"><u>underlined</u></span> text.
<span style="color:orange">This text is all orange</span>
```

---

# styling-font

Keep a space between the span tags and the markdown list

```markdown
<span style="font-size: 28px">

- this is a ine of **bulleted** text
- this is another line
- this markedth the third line
- ok, this is enough!

</span>
```

---

# mermaid-marp

To add a Mermaid chart to your presentation, try the code below.

NOTE: This works in a real web browser, so it should be good to go for your presentations. However, be aware that the letters aren't rendering correctly in the little Marp chrome preview window.

NOTE: You can put the last 3 lines at the top of your first slide for presentation wide Mermaid use. Otherwise, if it's just for one slide, you could use as shown.

```markdown
<!-- mermaid.js -->
<script src="https://unpkg.com/mermaid@8.1.0/dist/mermaid.min.js"></script>
<script>mermaid.initialize({startOnLoad:true});</script>

<div class="mermaid">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>
```

You can position diagrams using absolute coordinates and/or alter the bounding box like this:

```markdown
<div class="mermaid" style="position: absolute; top: 20px; right: 20px; width: 350px; height: auto;">
graph TD;
    A-->B;
    A-->C;
    B-->D;
    C-->D;
</div>
```

You can style nodes by creating a style for the node you'd like to style:

```markdown
<div class="mermaid">
graph TD;
  Node1-->Node2
  Node1-->Node3
  Node1-->Node4
  style Node4 fill:#bbf,stroke:#f66,stroke-width:2px,color:#fff,stroke-dasharray: 5 5
</div>
```

<font color:"orange">Unfortunately, this ^^^ styling renders correctly for me in the preview, but **NOT** in Firefox!?</font> 


By default, Mermaid diagrams can be small. You can put something like this in the Marp frontmatter section to adjust Mermaid diagram size:

```
  svg[id^="mermaid-"] { 
    min-width: 480px; 
    max-width: 960px; 
    min-height: 360px; 
    max-height: 600px; 
  }
```

<font color="orange">WARNING</font>: Mermaid doesn't work completely as expected in the Marp preview window.. If you want to preview Mermaid diagrams, drag slides.html to a real browser! **Even If You Do**, Mermaid diagrams <i>still</i> won't look as is should, though they will be readable. You have been warned!

---

# plotly-marp

To add a Plotly graph to your presentation, try the code below.

NOTE: You can put the first 3 lines at the top of your first slide for presentation wide Plotly use. Otherwise, if it's just for one slide, you could use as shown.

```markdown

<!-- Import Plotly dependencies -->
---

<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
<link rel="stylesheet" href="https://cdn.plot.ly/plotly-1.58.4.min.css" />

# Rate of Learning

(Total Time Hypothesis)

<div id="my-graph"></div>

<style scoped>
.plotly-graph-container {
  margin-top: 0;
  padding-top: 0;
}
</style>

<script>
// JavaScript code to create a Plotly graph
var data = [
  {
    x: [7.5, 20],
    y: [64, 8],
    type: 'scatter',
    line: {width: 4},
    marker: {size: 10} 
  }
];

var layout = {
  yaxis: {
    title: {text: "# Repetitions on Day 1", font: {size: 24}},
    autorange: 'reversed',
    range: [72, 0],
    tickvals: [0, 8, 16, 24, 32, 40, 48, 56, 64, 72]
  },
  xaxis: {
    title: {text: "Relearn Time on Day 2 (minutes)", font: {size: 24}},
    range: [0, 25],
    dtick: 5
  },
  margin: {t: 0, r: 0} // set top & right margins to 0
};
// 
Plotly.newPlot('my-graph', data, layout);
</script>

---

```

The above example is a little odd given it's reversed y-axis. Here is a slightly more conventional graph:

```markdown

---

<div id="plotly-graph"></div>

<script src="https://cdn.plot.ly/plotly-latest.min.js"></script>
<script>
  // Sample data
  const x = [1, 2, 3, 4, 5];
  const y = [10, 15, 13, 17, 20];

  // Create the Plotly graph
  const trace = {
    x: x,
    y: y,
    mode: 'lines+markers',
    type: 'scatter',
  };
  const data = [trace];
  const layout = {
    title: 'My Plotly Line Graph',
    xaxis: { title: 'X-axis' },
    yaxis: { title: 'Y-axis' },
  };
  Plotly.newPlot('plotly-graph', data, layout);
</script>

---

```


---

# useful-websites

- CommonMark Markdown Syntax [https://commonmark.org/help/](https://commonmark.org/help/)
- Marp Documentation [https://marpit.marp.app/markdown](https://marpit.marp.app/markdown)
