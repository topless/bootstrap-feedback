# rectangle x, y, width, height

class Shape
  settings:
    lineWidth   : 2
    fillStyle   : 'yellow'
    strokeStyle : 'green'

  constructor: (@rect) ->

  isHovered: (idx, x, y) ->
    if x > @rect.x and
    x < @rect.x + @rect.width and
    y > @rect.y and
    y < @rect.y + @rect.height
      console.log "Shape idx", idx
      $('.feedback-delete-btn')
        .css('left', @rect.x + @rect.width - 11)
        .css('top', @rect.y - 14)
        .data('shape', idx)
      console.log $('.feedback-delete-btn').data('shape')

  draw: (ctx) ->
    ctx.beginPath()
    ctx.rect(@rect.x, @rect.y, @rect.width, @rect.height)
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
    $('.feedback-delete-btn')
      .show()
      .on 'click', (event) ->
        console.log @
        console.log @shapes[$('.feedback-delete-btn').data('shape')]
        console.log @shapes.length
        @shapes.slice(parseInt($('.feedback-delete-btn').data('shape')), 1)
        console.log @shapes.length

  removeShape: (event, rect) =>
    for shape, idx in @shapes
      if rect.x == shape.x and rect.y == shape.y
        @shapes.splice(idx, 1)
        @drawAll()


  listen: ->
    $(window).on 'resize', => @init()

    $(window).on('remove:shape', @removeShape)

    @canvas.on 'mousedown', (event) =>
      return if event.which isnt 1 # only left clicks
      @centerX = event.pageX
      @centerY = event.pageY
      # begins new line
      @ctx.beginPath()
      @drawing = true

    @canvas.on 'mousemove', (event) =>
      currentX = event.pageX
      currentY = event.pageY

      for shape, idx in @shapes
        shape.isHovered(idx, currentX, currentY)

      if @drawing
        @draw(@centerX, @centerY, currentX, currentY)

    @canvas.on 'mouseup', (event) =>
      @drawing = false
      sizeX = event.pageX - @centerX
      sizeY = event.pageY - @centerY

      # if sizeX < @settings.minWidth then sizeX = @settings.minWidth
      # if sizeY < @settings.minHeight then sizeX = @settings.minHeight

      @shapes.unshift new Shape(
        x: @centerX
        y: @centerY
        width: sizeX
        height: sizeY
      )


  setSize: ->
    @canvas[0].width = parseInt $('body').width()
    @canvas[0].height = parseInt $('body').height()

  # canvas reset
  reset: ->
    @canvas[0].width = @canvas[0].width
    @drawAll()

  drawAll: ->
    return unless @shapes.length > 0
    shape.draw(@ctx) for shape in @shapes

  draw: (startX, startY, currentX, currentY) ->
    @reset()
    sizeX = currentX - startX
    sizeY = currentY - startY
    @ctx.rect(@centerX, @centerY, sizeX, sizeY)
    @ctx.lineWidth = @settings.lineWidth
    @ctx.fillStyle = @settings.fillStyle
    @ctx.fill()
    @ctx.strokeStyle = @settings.strokeStyle
    @ctx.stroke()


bootstrapFeedback = (options) ->

  settings = $.extend(
    html2canvasURL       : '//cdnjs.cloudflare.com/ajax/libs/html2canvas/0.4.1/html2canvas.min.js'
    initButtonText       : 	'Send feedback'
    feedbackButton       : '.feedback-btn'

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
    deleteBtn: """
      <a href="#" class="feedback-delete-btn" data-shape="-1">
        <i class="fa fa-2x fa-close"></i>
      </a>
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

  isHtml2CanvasLoaded = false
  $body = $('body')


  close: ->
    $('.feedback-select').hide()
    $('.feedback-canvas').hide()


  init: ->
    $body.append(templates.button)
    $body.append(templates.deleteBtn)
    $body.append(templates.select)
    @actions()


  getHtml2canvas: ->
    return unless not isHtml2CanvasLoaded
    $.getScript(settings.html2canvasURL, =>
      isHtml2CanvasLoaded = true
      @injectCanvas()
    )


  injectCanvas: ->
    $body.append(templates.canvas)
    new FeedbackCanvas(element: $('.feedback-canvas'))


  actions: ->
    $('.feedback-btn').on 'click', =>
      @getHtml2canvas()
      $('.feedback-select').drags()
      $('.feedback-select').show()
      $('.feedback-canvas').show()

    $('.feedback-close').on 'click', => @close()


$ ->
  # if (window.HTMLCanvasElement)
  options =
    ajaxURL: 'http://test.url.com/feedback'

  bootstrapFeedback(options).init()
  # $('.feedback-btn').click()
  # $.feedback(options)
