---
title: "Ansible"
permalink: /categories/ansible/
layout: archive
autho_profile: true
sidebar_main: true
---

{% assign posts = site.categories.Ansible %}
{% for post in posts %} {% include archive-single.html type=page.entries_layout %} {% endfor %}