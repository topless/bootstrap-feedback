bootstrap-feedback
==================

**Still work in progress**

A module for visual feedback based on Twitter Bootstrap

## Inspired from

- [niklasvh/feedback.js](https://github.com/niklasvh/feedback.js)
- [ivoviz/feedback](https://github.com/ivoviz/feedback)

## Setup

Load jQuery, the plugin and its CSS:

```html
<script src="//code.jquery.com/jquery-2.1.1.min.js"></script>
<script src="bootstrap-feedback.min.js"></script>
<link href="bootstrap-feedback.min.css" rel="stylesheet"/>
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
