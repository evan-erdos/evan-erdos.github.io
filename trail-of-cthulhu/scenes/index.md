---
layout: story
title: Scenes
---

Scenes
------

<ul>
{% for scene in site.pages %}
  {% if scene.layout == 'screenplay' %}
  	<li><a href="{{site.baseurl}}{{ scene.url }}"><i>{{ scene.title }}</i></a></li>
  {% endif %}
{% endfor %}
</ul>
