scrollTo = (el, topOffset = 20, leftOffset = 20) ->
  $('html,body').animate
    scrollTop: $(el).offset().top - topOffset
    scrollLeft: $(el).offset().left - leftOffset

html = '<%= j render partial: "overview", locals: { submission: @submission.decorate } %>'
container = $("#submissionOverviews")
id = '#submissionOverview-<%= @submission.id %>'
self = container.find id

container.fadeOut ->
  container.html(html).fadeIn()

## Slide up and down - like cards - behavior
#
# container.append(html) unless self.length > 0
# self = container.find id

# card = $("#submissionList").find(".submissionCard[data-id='<%= @submission.id %>']")
# $("#submissionList").find(".panel-body").not(card.find('.panel-body')).slideUp 'fast', =>
#   card.find(".panel-body").slideDown ->
#     container.find(".submissionOverview").not(self).addClass('being-hidden').slideUp 'slow', =>
#       self.slideDown('slow').removeClass('being-hidden')
