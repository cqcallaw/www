FILES := config.toml $(shell find archetypes content layouts static themes)

preview: draft
	$(eval CID = $(shell ipfs add --quiet -r draft | tee ipfs.log | tail -n 1))
	@echo Preview Link: http://dweb.link/ipfs/$(CID)

draft: $(FILES) static/resume.pdf
# disable hugo modification times; a large binary static file makes the timestamp sync logic go haywire
	hugo -D --debug --noTimes --destination draft
# manually touch the output folder so its mod time is correct
	touch draft

publish: public
	$(eval CID = $(shell ipfs add --quiet -r public | tee ipfs.log | tail -n 1))
	ipfs pin add $(CID)

public: $(FILES) static/resume.pdf
# disable hugo modification times; a large binary static file makes the timestamp sync logic go haywire
	hugo --noTimes --destination public
# manually touch the output folder so its mod time is correct
	touch public

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

clean:
	rm -rf static/resume.pdf public resources/_gen

# ref: https://stackoverflow.com/a/27770136/577298
.NOTPARALLEL:
