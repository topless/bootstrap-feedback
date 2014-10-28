class Shape

  settings:
    lineWidth   : 2
    fillStyle   : 'yellow'
    strokeStyle : 'green'


  constructor: (@x, @y, @width, @height) ->
    console.log "New shape: ", @x, @y, @width, @height


  isHovered: (idx, x, y) ->
    if x > @x and
    x < @x + @width and
    y > @y and
    y < @y + @height
      console.log "I am hovering button with idx: ", idx


  draw: (ctx) ->
    ctx.beginPath()
    ctx.rect(@x, @y, @width, @height)
    ctx.lineWidth = @settings.lineWidth
    ctx.fillStyle = @settings.fillStyle
    ctx.fill()
    ctx.strokeStyle = @settings.strokeStyle
    ctx.stroke()


class FeedbackCanvas

  settings:
    minWidth    : 30
    minHeight   : 30
    lineWidth   : 2
    fillStyle   : 'yellow'
    strokeStyle : 'green'

  templates:
    deleteBtn: """
      <a href="#" class="feedback-delete-btn" data-shape="-1">
        <i class="fa fa-2x fa-close"></i>
      </a>
    """

  constructor: (options) ->
    @drawing = false
    @canvas = options.element
    @ctx = @canvas[0].getContext('2d')
    @shapes = []
    @listen()
    @init()


  init: ->
    @setSize()
    @canvas.show()
    @drawAll()


  listen: ->
    $(window).on 'resize', => @init()
    $(window).on('remove:shape', @removeShape)
    @canvas.on 'mousedown', @onMouseDown
    @canvas.on 'mouseup', @onMouseUp
    @canvas.on 'mousemove', @onMouseMove


  onMouseDown: (event) =>
    # only left clicks
    return if event.which isnt 1
    @centerX = event.pageX
    @centerY = event.pageY
    @ctx.beginPath()
    @drawing = true


  onMouseMove: (event) =>
    currentX = event.pageX
    currentY = event.pageY

    for shape, idx in @shapes
      shape.isHovered(idx, currentX, currentY)

    if @drawing
      @drawMouse(@centerX, @centerY, currentX, currentY)


  onMouseUp: (event) =>
    console.log "@shapes.length: ", @shapes.length
    @drawing = false
    width = event.pageX - @centerX
    height = event.pageY - @centerY
    @shapes.push(new Shape(@centerX, @centerY, width, height))
    @canvas.append(@templates.deleteBtn)


  removeShape: (event, rect) =>
    for shape, idx in @shapes
      if rect.x == shape.x and rect.y == shape.y
        @shapes.splice(idx, 1)
        @drawAll()


  setSize: ->
    @canvas[0].width = parseInt $('body').width()
    @canvas[0].height = parseInt $('body').height()


  reset: ->
    @canvas[0].width = @canvas[0].width
    @drawAll()


  drawAll: ->
    return unless @shapes.length > 0
    for shape in @shapes
      shape.draw(@ctx)


  drawMouse: (startX, startY, currentX, currentY) ->
    @reset()
    width = currentX - startX
    height = currentY - startY
    @ctx.rect(@centerX, @centerY, width, height)
    @ctx.lineWidth = @settings.lineWidth
    @ctx.fillStyle = @settings.fillStyle
    @ctx.fill()
    @ctx.strokeStyle = @settings.strokeStyle
    @ctx.stroke()


bootstrapFeedback = (options) ->

  settings = $.extend(
    feedbackButton       : '.feedback-btn'
    html2canvasURL       : '//cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js'
    initButtonText       : 	'Send feedback'
    post:
      ajaxURL  : ''    # Your server url to send data.
      pageUrl  : true  # Url of the page sending feedback.
      htmlData : true  # HTML code of the page sending feedback.

  , options)

  templates =
    button: """
      <button class="feedback-btn">#{settings.initButtonText}</button>
    """
    canvas: """
      <canvas class="feedback-canvas"></canvas>
    """
    select: """
      <div class="feedback-select">
        <a href="#" class="feedback-close">&times;</a>
        <div class="row">
          <div class="col-md-12">
            <h2><i class="fa fa-bullhorn"></i> Feedback<h2>
            <h3>
            <small>
              Click and drag on the page to help us better understand your
              feedback. You can move this dialog if it is in the way.
            </small>
            </h3>
            <hr>
            <p class="col-md-12">
              <button class="feedback-sethighlight disabled col-md-3">
                <i class="fa fa-pencil"></i> Highlight
              </button>
              <label class="col-md-9">
                Highlight areas relevant to your feedback.
              </label>
            </p>
            <p class="col-md-12">
              <button class="feedback-setblackout col-md-3">
                <i class="fa fa-eraser"></i> Black Out
              </button>
              <label class="col-md-9">
                Black out any personal information.
              </label>
            </p>
            <!-- #feedback-highlighter-next -->
            <button class="pull-right">Next</button>
          </div>
        </div>
      </div>
    """

  isHtml2CanvasLoaded: false
  $body = $('body')


  init: ->
    $body.append(templates.button)
    $body.append(templates.select)
    @actions()


  close: ->
    $('.feedback-select').hide()
    $('.feedback-canvas').hide()


  actions: ->
    $('.feedback-close').on 'click', => @close()

    $('.feedback-btn').on 'click', =>
      @getHtml2Canvas()
      $('.feedback-select').drags().show()
      $('.feedback-canvas').show()

    $('.feedback-delete-btn')
      .show()
      .on 'click', (event) =>
        console.log @


  getHtml2Canvas: ->
    return unless not @isHtml2CanvasLoaded
    $.getScript(settings.html2canvasURL, =>
      @isHtml2CanvasLoaded = true
      $body.append(templates.canvas)
      window.bf = new FeedbackCanvas(element: $('.feedback-canvas'))
    )


$ ->
  # if (window.HTMLCanvasElement)
  options =
    ajaxURL: 'http://test.url.com/feedback'

  bootstrapFeedback(options).init()
  # $('.feedback-btn').click()
  # $.feedback(options)
