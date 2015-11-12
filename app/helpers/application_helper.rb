module ApplicationHelper
  def navbar_link(name, path, *args)
    content_tag :li, class: (request.path == path ? "active" : "") do
      link_to(name, path, *args)
    end
  end
end
