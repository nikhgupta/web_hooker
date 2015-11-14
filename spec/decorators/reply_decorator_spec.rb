require 'spec_helper'

describe ReplyDecorator, type: :decorator do
  let(:reply){ create :reply, http_status_code: nil }
  def decorated; reply.reload.decorate; end

  describe "#status_style" do
    it "returns css style for the reply based on its status" do
      expect(decorated.status_style).to eq :warning
      expect(Reply.new.decorate.status_style).to eq :warning

      reply.update_attribute :http_status_code, 200
      expect(decorated.status_style).to eq :success

      reply.update_attribute :http_status_code, 400
      expect(decorated.status_style).to eq :danger
    end
  end
end
