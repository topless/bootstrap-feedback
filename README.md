bootstrap-feedback
==================

# Still work in progress

A module for visual feedback based on Twitter Bootstrap

# Inspired from

### [niklasvh](nk) /  [feedback.js](fbjs)
  [nk]: https://github.com/niklasvh  "Optional Title Here"
  [fbjs]: https://github.com/niklasvh/feedback.js

### and

### [ivoviz](iv) / [feedback](fb)
  [iv]: http://github.com/ivoviz
  [fb]: http://ivoviz.github.io/feedback/

##Setup
Load jQuery, the plugin, and its CSS:
```html
  <script src="https://code.jquery.com/jquery-2.1.1.min.js"></script>
  <script src="feedback.min.js"></script>
  <link rel="stylesheet" href="feedback.min.css" />
```


## Init
You can override html2canvas if you want to load it from your local server,
By default it is going to be loaded asynchronously when the user clicks feedback
button from the CDN below.
```
//cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js
```

```js
var options = {
  html2canvasURL: '/path/to/html2canvas.js';
}
$.feedback(options);
```
