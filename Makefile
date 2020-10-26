FILES := config.toml $(shell find archetypes content layouts static themes) static/resume.pdf

all: cweb dweb

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

cweb: $(FILES)
	hugo -d --noTimes cweb

dweb: $(FILES)
	hugo -d dweb --noTimes --baseURL '/'

clean:
	rm -rf static/resume.pdf public cweb dweb
