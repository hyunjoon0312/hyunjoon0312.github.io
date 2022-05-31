---
title: "Web"
permalink: /categories/web/
layout: archive
autho_profile: true
sidebar_main: true
---

{% assign posts = site.categories.Web %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}