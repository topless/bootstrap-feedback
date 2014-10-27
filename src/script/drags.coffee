(($) ->
  $.fn.drags = (opt) ->
    opt = $.extend(
      handle: ""
      cursor: "move"
    , opt)
    if opt.handle is ""
      $el = this
    else
      $el = @find(opt.handle)
    # disable selection
    $el.css("cursor", opt.cursor).on("mousedown", (e) ->
      if opt.handle is ""
        $drag = $(this).addClass("draggable")
      else
        $drag = $(this).addClass("active-handle").parent().addClass("draggable")
      z_idx = $drag.css("z-index")
      drg_h = $drag.outerHeight()
      drg_w = $drag.outerWidth()
      pos_y = $drag.offset().top + drg_h - e.pageY
      pos_x = $drag.offset().left + drg_w - e.pageX
      $drag.css("z-index", 1000).parents().on "mousemove", (e) ->
        $(".draggable").offset(
          top: e.pageY + pos_y - drg_h
          left: e.pageX + pos_x - drg_w
        ).on "mouseup", ->
          $(this).removeClass("draggable").css "z-index", z_idx
          return

        return

      e.preventDefault()
      return
    ).on "mouseup", ->
      if opt.handle is ""
        $(this).removeClass "draggable"
      else
        $(this).removeClass("active-handle").parent().removeClass "draggable"
      return

  return
) jQuery
