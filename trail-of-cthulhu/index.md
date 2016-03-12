---
layout: story
title: Red Tide Rising
---

<img src="/trail-of-cthulhu/assets/logo.png" style="margin-left:auto; margin-right:auto; display:block;">


A Lovecraftian horror story, written for the Trail of Cthulhu Game System.

{% assign acts = (site.pages | sort:'url') %}
<ul>
{% for act in acts %}
  {% if act.layout == 'act' %}
    <li><a href="{{ site.baseurl }}{{ act.url }}">{{ act.title }}</a></li>
    <ul>
    {% for sequence in acts %}
      {% if sequence.layout == 'sequence' and sequence.url contains act.url %}
        <li><a href="{{ site.baseurl }}{{ sequence.url }}">{% if sequence.seq %}Sequence {{ sequence.seq | plus:1 }} : {% endif %}{{ sequence.title }}</a></li>
        <ul class="fa-ul">
        {% for scene in acts %}
          {% if scene.layout == 'scene' and scene.url contains sequence.url %}
            <li><a href="{{ site.baseurl }}{{ scene.url }}">
            <span class="beat">
            {% if scene.beat %}{% include trail/beat/{{ scene.beat }}.html %}{% endif %}
            </span>
            {% if scene.scene %}Scene {{ scene.scene | plus:1 }} : {% endif %}<i>{{ scene.title }}</i></a></li>
          {% endif %}
          {% endfor %}
        </ul>
      {% endif %}
      {% endfor %}
    </ul>
  {% endif %}
{% endfor %}
</ul>









