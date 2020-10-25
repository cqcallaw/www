all: cweb dweb

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

cweb: config.toml static/resume.pdf
	hugo -d cweb

dweb: config.toml static/resume.pdf
	hugo -d dweb --baseURL '/'
	ipfs add -r dweb

clean:
	rm -rf static/resume.pdf public cweb dweb

FORCE: ;
