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
      {% include post_title.html %}
      </a></h1></span>
      <div class="entry">
        {{ post.excerpt }}
      </div>
      <hr>
    </article>
  {% endfor %}
</div>