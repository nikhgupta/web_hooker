ready = ->

  scrollTo = (el, selector, topOffset = 20, leftOffset = 20) ->
    $(selector).animate
      scrollTop:  $(selector).scrollTop() + $(el).offset().top  - topOffset
      scrollLeft: $(selector).scrollTop() + $(el).offset().left - leftOffset

  # Request overview for the submission when selected
  $(".submissionCard .panel-heading").click ->
    card = $(@).parent()
    $.getScript("/submissions/#{card.data('id')}.js").done ->
      body = card.find(".panel-body")
      $(".submissionCard .panel-body").not(body).slideUp()
      body.slideDown => scrollTo card, "#submissionList", 70

$(document).ready(ready)
$(document).on('page:load', ready)
