all: resume cweb dweb

resume: FORCE
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

cweb: FORCE
	hugo --debug -d cweb

dweb: FORCE
	hugo --debug -d dweb --baseURL 'ipfs://www.brainvitamins.eth/'

clean:
	rm -rf static/resume.pdf public cweb dweb

FORCE: ;