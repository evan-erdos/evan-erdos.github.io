---
layout: post
title: SocialVR Web Form Template
tags: [Programming, GameDev]
---


Generates a block of `*.yml` text from the input.



<style type="text/css">
  #drag-1, #drag-2, #drag-3, #drag-4, #drag-5, #drag-6, #drag-7, #drag-8{
  width: 50px;
  height: 50px;
  min-height: 3.5em;
  margin: 1%;

  background-color: #ffcccc;
  color: white;

  border-radius: 4em;
  padding: 1%;

  -webkit-transform: translate(0px, 0px);
          transform: translate(0px, 0px);
}

#drag-me::before {
  content: "#" attr(id);
  font-weight: bold;
}
</style>



<div id="drag-1" class="draggable">
  <p> 1 </p>
</div>
<div id="drag-2" class="draggable">
    <p> 2 </p>
</div>
<div id="drag-3" class="draggable">
    <p> 3 </p>
</div>
<div id="drag-4" class="draggable">
    <p> 4 </p>
</div>
<div id="drag-5" class="draggable">
    <p> 5 </p>
</div>
<div id="drag-6" class="draggable">
    <p> 6 </p>
</div>
<div id="drag-7" class="draggable">
    <p> 7 </p>
</div>
<div id="drag-8" class="draggable">
    <p> 8 </p>
</div>


<script src="{{site.baseurl}}/code/lib/interact.js"></script>

<form id="form" onchange="window.submit()"></form>

<script type="text/javascript" src="{{site.baseurl}}/code/templateForm.js"></script>



<script>
  function handleFileSelect(e) {
    var files = e.target.files; // FileList object

    // Loop through the FileList and render image files as thumbnails.
    for (var i = 0, f; f = files[i]; i++) {

      // Only process image files.
      if (!f.type.match('image.*')) continue;

      var reader = new FileReader();

      reader.onload = (function(theFile) {
        return function(e) {
          var span = document.createElement('span');
          span.innerHTML = ['<img class="thumb" src="', e.target.result,
                            '" title="', escape(theFile.name), '"/>'].join('');
          document.getElementById('span').insertBefore(span, null);
        };
      })(f);

      reader.readAsDataURL(f);
    }
  }

  document.getElementById('form').addEventListener('change', handleFileSelect, false);
</script>




