---
title: "Linting"
slug: "linting"
date: 2020-10-30T22:16:10-07:00
draft: false
tags: ["dweb", "style"]
---

I'm slightly addicted to linting tools. Green check marks and empty error lists make me feel safe, as if the collected wisdom of my fellow practitioners, born of hard experience, had nothing to offer except an approving nod; _you did good, kid._

I've tinkered with websites long enough to remember when "Valid XHTML" buttons were hip, so [W3C Markup Validator](https://validator.w3.org/) was an early stop, by way of an [issue](https://github.com/htacg/tidy-html5/issues/903) in [HTML Tidy](https://github.com/htacg/tidy-html5). Issues aside, I'm pleased to see how seamlessly Tidy integrates into the build process. Wrangling Hugo templates to until the indentation was exactly right seemed a Sisyphean task, but Tidy gets the job done _post hoc_. It would be rude to visit the markup validator without looking in on [style sheet validation](https://jigsaw.w3.org/css-validator/), though the [spew of warnings](https://jigsaw.w3.org/css-validator/validator?uri=https%3A%2F%2Fwww.brainvitamins.net%2F&profile=css3svg&usermedium=all&warning=1&vextwarning=&lang=en) triggered by my chosen Hugo theme may exhaust my appetite for cleanliness.

New additions to the toolkit include [markdownlint](https://github.com/DavidAnson/markdownlint) to level up my Markdown game, and [Lighthouse](https://developers.google.com/web/tools/lighthouse/), which was a completely accidental discovery that has nonetheless proven to be a delightful rabbit hole of best practices. I expect more goodness in this dimension, visible only to folks that Inspect elements regularly. You know who you are.
