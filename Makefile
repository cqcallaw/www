FILES := config.toml $(shell find archetypes content layouts static themes) static/resume.pdf

all: cweb dweb

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

cweb: $(FILES)
	hugo -d cweb
	# correct modification time;
	# for some reason Hugo output sets the modification time to Dec 13 1901
	find cweb -exec touch {} +

dweb: $(FILES)
	hugo -d dweb --baseURL '/'
	# correct modification time;
	# for some reason Hugo output sets the modification time to Dec 13 1901
	find dweb -exec touch {} +
	ipfs add -r dweb

clean:
	rm -rf static/resume.pdf public cweb dweb
