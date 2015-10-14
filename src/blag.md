---
layout: default
title: Blag
permalink: /blag/
---

<div class="posts">
  {% for post in site.posts %}
    <article class="post">
      {% if post.img %}
        <a href="{{ site.baseurl }}{{ post.url }}"><img src="{{ post.img }}" align="left" style="width: 256px;"></a>
      {% endif %}
      <span><h1><a href="{{ site.baseurl }}{{ post.url }}">
        {{ post.title }}{% if post.version %}<span class="version"> v{{ post.version }}</span>{% endif %}
      </a></h1></span>
      <div class="entry">
        {{ post.excerpt }}
      </div>
      <hr>
    </article>
  {% endfor %}
</div>