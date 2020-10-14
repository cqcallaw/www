all: cweb dweb

resume: FORCE
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

cweb: resume FORCE
	hugo --debug -d cweb

dweb: resume FORCE
	hugo --debug -d dweb --baseURL 'ipfs://www.brainvitamins.eth/'

clean:
	rm -rf static/resume.pdf public cweb dweb

FORCE: ;