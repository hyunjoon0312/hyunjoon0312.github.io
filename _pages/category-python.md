---
title: "Python"
permalink: /categories/python/
layout: archive
autho_profile: true
sidebar_main: true
---

{% assign posts = site.categories.Python %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}