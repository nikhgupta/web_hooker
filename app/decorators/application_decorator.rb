class ApplicationDecorator < Draper::Decorator
  delegate_all

  def label_for(attribute, options = {})
    h.content_tag(
      :span, model.send(attribute),
      class: "label label-#{options.fetch(:style, :default)}"
    )
  end

  def timestamp_for(attribute, options = {})
    timestamp = model.send attribute
    h.content_tag(
      :span, "#{h.time_ago_in_words timestamp} ago",
      class: "timestamp #{options[:class]}",
      data: { timestamp: timestamp.iso8601 }
    )
  end
end
