FILES := config.toml $(shell find archetypes content layouts static themes)

preview:
	hugo -D --debug server --baseUrl "http://localhost/"

publish: public
	$(eval CID = $(shell ipfs add --quiet -r public | tee ipfs.log | tail -n 1))
	ipfs pin add $(CID)
	@echo Preview Link: http://dweb.link/ipfs/$(CID)

public: $(FILES) static/resume.pdf
# disable hugo modification times; a large binary static file makes the timestamp sync logic go haywire
	hugo --noTimes --destination public
# manually touch the output folder so its mod time is correct
	touch public
# tidy up auto-generated HTML
	find public -name *.html -exec tidy -quiet -i -w 120 -m {} \;

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

clean:
	rm -rf static/resume.pdf public resources/_gen

# ref: https://stackoverflow.com/a/27770136/577298
.NOTPARALLEL:
