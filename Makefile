all: resume static-site

resume: FORCE
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

static-site: FORCE
	hugo --debug

clean:
	rm -rf static/resume.pdf public

FORCE: ;