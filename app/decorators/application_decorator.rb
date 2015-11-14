class ApplicationDecorator < Draper::Decorator
  delegate_all

  def label_for(attribute, options = {})
    value = model.send(attribute)
    value = yield(value) if block_given?
    return if value.blank?
    h.content_tag(:span, value.to_s, class: "label label-#{options.fetch(:style, :default)} #{options[:class]}")
  end

  def missing_label_for(attribute, options = {})
    label_for(attribute, options) do |val|
      val = yield(val) if block_given?
      "#{attribute.to_s.titleize} missing" if val.blank?
    end
  end

  def timestamp_for(attribute, options = {})
    timestamp = model.send attribute
    timestamp = yield(timestamp) if block_given?
    return if timestamp.blank?
    h.content_tag(
      :span, "#{h.time_ago_in_words timestamp} ago",
      class: "timestamp #{options[:class]}",
      data: { timestamp: timestamp.iso8601 }
    )
  end

  def headers_list
    text, headers = [], (model.headers.try(:dup) || {})
    text << "#{headers.delete("Version")} #{headers.delete("Host")}"
    headers.each{ |key, val| text << "#{key}: #{val}" }
    text.select(&:present?)
  end

  def headers_with_body
    return headers_list if model.body.blank?
    return [model.body] if headers_list.blank?
    list = headers_list << "" << "" << model.body
    list.all?(&:blank?) ? [] : list
  end
end
