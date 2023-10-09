SHELL = /bin/bash

TSDIR   ?= $(CURDIR)/tree-sitter-regex
TESTDIR ?= $(TSDIR)/examples

all:
	@

dev: $(TSDIR)
$(TSDIR):
	@git clone --depth=1 https://github.com/tree-sitter/tree-sitter-regex
	@printf "\33[1m\33[31mNote\33[22m npm build can take a while\e[0m\n" >&2
	cd $(TSDIR) &&                                         \
		npm --loglevel=info --progress=true install && \
		npm run generate

.PHONY: parse-%
parse-%:
	cd $(TSDIR) && npx tree-sitter parse $(TESTDIR)/$(subst parse-,,$@)

clean:
	$(RM) -r *~

distclean: clean
	$(RM) -rf $$(git ls-files --others --ignored --exclude-standard)
