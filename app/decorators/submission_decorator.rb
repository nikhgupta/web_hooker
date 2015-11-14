class SubmissionDecorator < ApplicationDecorator
  decorates_association :portal

  def uuid
    h.content_tag(:code, model.uuid)
  end

  def status
    model.status.to_s.titleize
  end

  def request_method
    model.request_method.upcase
  end

  def accept_type
    model.headers.try :[], 'Accept'
  end

  def received_at
    html  = model.created_at.utc.strftime("%A, %B %d, %Y %H:%M %Z")
    "#{html} &mdash; #{timestamp_for(:created_at)}".html_safe
  end

  def portal_link
    h.link_to model.portal.title, h.portal_url(model.portal)
  end

  def size
    cl = model.content_length
    return "#{cl.to_i} #{"byte".pluralize(cl)}" if cl < 1024/10
    %w(KB MB GB).each_with_index do |unit, i|
      return "%0.2f#{unit}" % (cl/1024.0 ** (i+1)) if cl < 1024 ** (i+2) / 10
    end
    return "wtf!"
  end

  def status_style
    case model.status
    when :failed then :danger
    when :successful then :success
    when :pending then :default
    else :warning
    end
  end

  def ping_balls
    %w(pending successful failed).map do |status|
      count = model.send("#{status}_replies_count")
      count.times.map do
        h.content_tag(:span, nil, class: "ping-ball #{status}")
      end
    end.flatten.join("").html_safe
  end
end
