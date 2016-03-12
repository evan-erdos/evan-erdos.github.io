---
layout: story
title: Setting
---

Setting
-------

<ul>
{% for setting in site.pages %}
    {% if setting.layout == 'setting' %}
    	<li><a href="{{ site.baseurl }}{{ setting.url }}">{{ setting.title }}</a></li>
    {% endif %}
{% endfor %}
</ul>