FILES := config.toml $(shell find archetypes content layouts static themes)

public: $(FILES) static/resume.pdf
	hugo --noTimes
	ipfs add -r public

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

clean:
	rm -rf static/resume.pdf public
