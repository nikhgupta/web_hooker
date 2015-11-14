class ReplyDecorator < ApplicationDecorator
  def status_style
    case model.status
    when :failed then :danger
    when :successful then :success
    else :warning
    end
  end
end
