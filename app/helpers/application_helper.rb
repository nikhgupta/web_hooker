module ApplicationHelper
  def navbar_link(name, path, *args)
    content_tag :li, class: (request.path == path ? "active" : "") do
      link_to(name, path, *args)
    end
  end

  def riot_tag_for(name, type, data, options = {})
    collection = options.delete(:collection)
    serializer = "#{name}_serializer".camelize.constantize
    name = name.to_s.pluralize if collection
    data = collection ? data.map{|item| serializer.new(item, scope: self)} : serializer.new(data, scope: self)
    riot_component :div, "#{name}_#{type}", options.merge("#{name}" => data)
  end
end
