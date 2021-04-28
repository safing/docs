---
title: Markdown Guideline
layout: base
---

### Paragraphs

When writing paragraphs of text, start a new line for each new sentence in order for clearer changelogs. This will _not_ create a linebreak without a trailing doublespace `  ` or a double linebreak.

### Header Guideline

- `<h1>` NEVER use - this is automatically used for the page header

- `<h2>` Rarely use - only when the page itself is logically split into multiple parts. An example of this is [OS Integration](/portmaster/architecture/os-integration) where one section describes Windows and the other Linux. Here, a `<h2>` is fine

- `<h3>` The default. Every bigger section of a documentation page will use a `<h3>` as a header.

- `<h4>` Overall Sub-Section of a main page <h3> section. An Example is found in [DNS Configuration](http://localhost:3000/portmaster/guides/dns-configuration)

- `<h5>` Rarely use. A Sub-Sub Section worth mentioning in the Table of Content (TOC). An example can be found at [Architecture > Core Service > Core](http://localhost:3000/portmaster/architecture/core-service/core).

- `<h6>` Use for small headers which should not be part of the Table of Content (TOC). The TOC automatically excludes these. Previously, we used `**bold**` markdown for this - but that quickly becomes messy from a HTML & CSS perspective. Hence the move to `<h6>`
