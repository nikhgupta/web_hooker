jQuery ->

  scrollTo = (el, selector = 'html,body', topOffset = 20, leftOffset = 20) ->
    $(selector).animate
      scrollTop: $(el).offset().top - topOffset
      scrollLeft: $(el).offset().left - leftOffset


  # Resize sidebar as per the document/window height
  # resizeSubmissionListHeight = ->
  #   max_height = Math.min($(document).height(), $(window).height())
  #   $("#submissionList").css "height", max_height - 50
  # resizeSubmissionListHeight()
  # $(window).resize -> resizeSubmissionListHeight()

  # Request overview for the submission when selected
  $(".submissionCard .panel-heading").click ->
    # $.getScript "/submissions/#{$(@).parent().data('id')}.js", =>
    #   $(@).parent().find(".panel-body").slideDown => scrollTo(@, 70)
    # $(@).parents("#submissionList").find(".panel-body").not(self).slideUp()
    $.getScript "/submissions/#{$(@).parent().data('id')}.js"

  $(".submissionCard .panel-heading:first()").trigger('click')
