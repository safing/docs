# Data

### Update faq-data.json

1. Check if the current list has new entries

    https://github.com/issues?q=archived%3Afalse+user%3Asafing+sort%3Aupdated-desc+label%3Afaq

2. Get the current list with these commands (you might need to add new ones for additional repos)

```
gh issue list --label faq --repo safing/portmaster --json title,url,body > faq-data.json
gh issue list --label faq --repo safing/portmaster-ui --json title,url,body >> faq-data.json
```

3. Fix JSON format.

```
sed -i ':a;N;$!ba;s/\]\n\[/,/g;s/},{/},\n{/g;s/\[{/\[\n{/g;s/}\]/}\n\]/g' faq-data.json
```

4. Sort and make pretty

```
cat faq-data.json | jq 'sort_by(.title)' | tee faq-data.json
```

Here is everything together:

```
gh issue list --label faq --repo safing/portmaster --json title,url,body > faq-data.json && \
gh issue list --label faq --repo safing/portmaster-ui --json title,url,body >> faq-data.json && \
sed -i ':a;N;$!ba;s/\]\n\[/,/g;s/},{/},\n{/g;s/\[{/\[\n{/g;s/}\]/}\n\]/g' faq-data.json && \
cat faq-data.json | jq 'sort_by(.title)' | tee faq-data.json
```
