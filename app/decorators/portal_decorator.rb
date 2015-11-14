class PortalDecorator < ApplicationDecorator
  def title_label
    label_for :title, style: :info
  end
end
