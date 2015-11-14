html = '<%= j render partial: "overview", locals: { submission: @submission.decorate } %>'
el = $("#submissionOverview")
el.fadeOut 'fast', -> el.html(html).fadeIn 'slow'
