# Be quieter about recursive make
MAKEFLAGS += --no-print-directory

# Optional: silence all recipe command echos
# MAKEFLAGS += -s

# Helper: prompt + commit
GITCOMMIT = read -p 'Enter commit message: ' msg; git commit -m "$$msg"

.PHONY: stage commit push deploy update

stage:
	@git add .

commit:
	@$(GITCOMMIT)

compile:
	@sh docs/do_convert.sh

push:
	@git push

deploy:
	@sh ./deploy.sh

update:
	@$(MAKE) compile
	@$(MAKE) stage
	@$(MAKE) commit
	@$(MAKE) push
	@$(MAKE) deploy