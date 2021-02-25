FILES := config.toml $(shell find archetypes assets content layouts static themes)

preview:
	hugo -D --debug server --baseUrl "http://localhost/"

publish: www-update ipfs

www-update: git-publish
# update conventional web view
	ssh www.brainvitamins.net 'cd ~/src/www/ && git pull origin master && make clean public && chmod -R 0755 public && rsync -arh --delete ~/src/www/public/ /var/www/html/'

ipfs: git-publish sign
# publish to IPFS
	$(eval CID = $(shell ipfs add --quiet -r public | tee ipfs.log | tail -n 1))
	ipfs pin add $(CID)
	@echo Preview Link: http://dweb.link/ipfs/$(CID)

sign: public
	./sign.py public

git-publish: public
# make sure we're on the master branch
	git branch --show-current | grep 'master'
# make sure remote master is up-to-date
	git push origin master

public: $(FILES) static/resume.pdf
# disable hugo modification times; a large binary static file makes the timestamp sync logic go haywire
	hugo --noTimes --destination public
# manually touch the output folder so its mod time is correct
	touch public
# tidy up auto-generated HTML
	find public -name *.html -exec tidy --tidy-mark no -quiet -i -w 120 -m {} \;

static/resume.pdf: static/resume.tex
	cd static && pdflatex -aux-directory=/dev/null resume.tex && rm -f resume.aux resume.log

clean:
	rm -rf static/resume.pdf public resources/_gen gnupg-tmp

# ref: https://stackoverflow.com/a/27770136/577298
.NOTPARALLEL:
