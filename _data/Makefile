# Fetch and process FAQs, releases and versions.

.PHONY: faq-data releases-data versions-data clean

all: faq/all.json releases/all.json versions-data

update: clean all

faq/all.json: faq-data
	jq -s 'add | map({title, html_url, body}) | map(.keywords = (.body | capture("Keywords: (?<c>[^\r\n]+)").c | split(", "))) | map(.categories = (.body | capture("Categories: (?<c>[^\r\n]+)").c | split(", "))) | sort_by(.title)' faq/src/* > $@
	if [ $(shell jq -s 'add | length' faq/src/*) != $(shell jq 'length' $@) ]; then echo "missing faq entries in $@"; exit 1; fi

faq-data: faq/src/portmaster.json faq/src/portmaster-ui.json faq/src/spn.json faq/src/faqs.json

faq/src/%.json:
	mkdir -p faq/src
	cd faq/src
	wget -O $@ "https://api.github.com/repos/safing/$*/issues?labels=faq&per_page=100"

releases/all.json: releases-data
	jq -s 'add | map({name, tag_name, body, prerelease, html_url, created_at}) | map(.date = .created_at[:10]) | map(.body = (.body | gsub("Changelog:"; "") | gsub("[a-f0-9]{40}"; "-"))) | map(.repo = (.html_url | capture("github.com/safing/(?<repo>[^/]+)/").repo)) | sort_by(.created_at) | reverse' releases/src/* > $@

releases-data: releases/src/portmaster.json releases/src/portmaster-ui.json releases/src/spn.json

releases/src/%.json:
	mkdir -p releases/src
	cd faq/src
	wget -O $@ "https://api.github.com/repos/safing/$*/releases"

versions-data: versions/stable.json versions/beta.json

versions/%.json:
	cd versions
	wget -O $@ "https://updates.safing.io/$*.v2.json"

clean:
	rm -f faq/src/*
	rm -f releases/src/*
	rm -f versions/*
