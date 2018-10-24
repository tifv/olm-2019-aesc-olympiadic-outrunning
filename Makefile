TEX = $(shell python2 contents.pygen --list)

first: allpdf

test:
	@echo $(TEX)

define PIECE =
allpdf: output/$(subst /,-,$(theTEX:.tex=.pdf))
output/$(subst /,-,$(theTEX:.tex=.pdf)): output/$(subst /,-,$(theTEX)) $(theTEX)
output/$(subst /,-,$(theTEX)): main.tex
	{ \
	    sed '/\\begin{document}/q' main.tex; \
	    echo "\\input{$(theTEX)}"; \
	    echo '\end{document}'; \
	} > output/$(subst /,-,$(theTEX))
test: test/$(subst /,-,$(theTEX:.tex=.pdf))
test/$(subst /,-,$(theTEX:.tex=.pdf)):
	@echo $$@ $(subst /,-,$(theTEX:.tex=.pdf)) $(subst /,-,$(theTEX))
endef

output/%.pdf:
	latexmk -pdf \
	    -output-directory=output \
	    -halt-on-error \
	    -interaction=nonstopmode \
	    -jobname=$* \
	    $<

$(foreach theTEX,$(TEX),$(eval $(PIECE)))

.PHONY: first allpdf

