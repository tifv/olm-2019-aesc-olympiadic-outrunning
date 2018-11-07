TEX = $(shell python2 contents.pygen --list)

OUTDIR = .output

first: allpdf

test:
	@echo $(TEX)

define PIECE =
allpdf: $(OUTDIR)/$(subst /,-,$(theTEX:.tex=.pdf))
$(OUTDIR)/$(subst /,-,$(theTEX:.tex=.pdf)): $(OUTDIR)/$(subst /,-,$(theTEX)) $(theTEX)
$(OUTDIR)/$(subst /,-,$(theTEX)): main.tex | $(OUTDIR)
	{ \
	    sed '/\\begin{document}/q' main.tex; \
	    echo "\\input{$(theTEX)}"; \
	    echo '\end{document}'; \
	} > $(OUTDIR)/$(subst /,-,$(theTEX))
test: test/$(subst /,-,$(theTEX:.tex=.pdf))
test/$(subst /,-,$(theTEX:.tex=.pdf)):
	@echo $$@ $(subst /,-,$(theTEX:.tex=.pdf)) $(subst /,-,$(theTEX))
endef

$(OUTDIR)/%.pdf:
	latexmk -pdf \
	    -output-directory=$(OUTDIR) \
	    -halt-on-error \
	    -interaction=nonstopmode \
	    -jobname=$* \
	    $<

$(OUTDIR):
	mkdir -p $@

$(foreach theTEX,$(TEX),$(eval $(PIECE)))

.PHONY: first allpdf

