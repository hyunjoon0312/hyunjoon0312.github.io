---
title: "Linux"
permalink: /categories/linux/
layout: archive
autho_profile: true
sidebar_main: true
---

{% assign posts = site.categories.Linux %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}