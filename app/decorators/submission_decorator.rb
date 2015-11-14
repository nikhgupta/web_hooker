class SubmissionDecorator < ApplicationDecorator
  decorates_association :portal

  def status_style
    case model.status
    when :failure then :danger
    when :successful then :success
    when :pending, :partially_successful then :warning
    else :info
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

  def headers_list
    headers = model.headers
    text  = []
    text << "#{headers.delete("Version")} #{headers.delete("Host")}"
    headers.each{ |key, val| text << "#{key}: #{val}" }
    text.join("<br/>").html_safe
  end
end
