# Makefile for generating minified files

.PHONY: all

# we cheat and process all .js files instead of an exhaustive list
all: $(patsubst %.js,%.min.js,$(filter-out %.min.js,$(wildcard inst/htmlwidgets/lib/flot/*.js)))

%.min.js: %.js
	yuicompressor $< -o $@

clean: 
	rm $(wildcard inst/htmlwidgets/lib/flot/*min.js)
