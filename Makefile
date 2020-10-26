FILES := config.toml $(shell find archetypes content layouts static themes)

public: $(FILES) static/resume.pdf
# disable hugo modification times; a large binary static file makes the timestamp sync logic go haywire
	hugo --noTimes --destination public
# manually touch the output folder so its mod time is correct
	touch public
	ipfs add -r public

preview:
	$(eval CID = $(shell ipfs add --quiet -r public | tee ipfs.log | tail -n 1))
	@echo Preview Link: http://dweb.link/ipfs/$(CID)

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

clean:
	rm -rf static/resume.pdf public

# ref: https://stackoverflow.com/a/27770136/577298
.NOTPARALLEL:
