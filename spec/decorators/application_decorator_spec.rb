RSpec.describe ApplicationDecorator, type: :decorator do
  let(:model){ spy("model") }
  let(:decorator_class){ Class.new(ApplicationDecorator) }
  let(:decorator){ decorator_class.decorate(model) }

  it "delegates all methods to base model, by default" do
    allow(model).to receive(:ping).and_return :pong
    expect(decorator.ping).to eq :pong
  end

  describe "#label_for" do
    it "generates html for producing a label for the given model attribute" do
      allow(model).to receive(:name).and_return "modelx"
      html = decorator.label_for(:name)
      expect(html).to have_selector("span.label.label-default", text: "modelx")
    end

    it "optionally, allows setting the style class for the label tag" do
      allow(model).to receive(:count).and_return 10
      html = decorator.label_for(:count, style: :whatever)
      expect(html).to have_selector("span.label.label-whatever", text: "10")
    end

    it "generates nothing if the attribute value is blank" do
      allow(model).to receive(:ping).and_return "   "
      expect(decorator.label_for :ping, style: :whatever).to be_nil
    end

    it "allows yielding the attribute value to a block and use that value instead" do
      allow(model).to receive(:even).and_return 1
      html = decorator.label_for(:even, style: :whatever){|v| v * 2}
      expect(html).to have_selector("span.label.label-whatever", text: "2")
    end
  end

  describe "#missing_label_for" do
    it "generates html for producing a label when the model attribute is missing" do
      allow(model).to receive(:ping).and_return "   "
      html = decorator.missing_label_for(:ping, class: "whatever")
      expect(html).to have_selector("span.label.label-default.whatever", text: "Ping missing")
    end

    it "optionally, allows setting the style class for the label tag" do
      allow(model).to receive(:ping).and_return nil
      html = decorator.missing_label_for(:ping, style: :whatever)
      expect(html).to have_selector("span.label.label-whatever", text: "Ping missing")
    end

    it "allows yielding the attribute value to a block and use that value instead" do
      allow(model).to receive(:even).and_return 1
      html = decorator.missing_label_for(:even, style: :whatever){|v| v.odd?}
      expect(html).to be_blank
      html = decorator.missing_label_for(:even, style: :whatever){|v| v.even?}
      expect(html).to have_selector("span.label.label-whatever", text: "Even missing")
    end
  end

  describe "#timestamp_for" do
    it "generates HTML for producing a live-timestamp for the given model attribute" do
      travel_to Time.new(2000, 01, 01, 01, 01, 01, "+00:00")
      allow(model).to receive(:processed_at).and_return 1.hour.ago
      html = decorator.timestamp_for(:processed_at)
      selector = "span.timestamp[data-timestamp='2000-01-01T00:01:01Z']"
      expect(html).to have_selector(selector, text: "about 1 hour ago")
    end

    it "allows yielding the attribute value to a block and use that value instead" do
      travel_to Time.new(2000, 01, 01, 01, 01, 01, "+00:00")
      allow(model).to receive(:created_at).and_return 2.hours.ago

      html = decorator.timestamp_for(:created_at, class: :whatever){|v| v + 1.hour}
      selector = "span.timestamp[data-timestamp='2000-01-01T00:01:01Z']"
      expect(html).to have_selector(selector, text: "about 1 hour ago")
    end
  end

  describe "#headers_list" do
    it "creates a string array containing header lines" do
      allow(model).to receive(:headers).and_return(nil)
      expect(decorator.headers_list).to eq([])

      allow(model).to receive(:headers).and_return({})
      expect(decorator.headers_list).to eq([])

      allow(model).to receive(:headers).and_return("Version" => "HTTP/1.1", "Key1" => "Value1", "Host" => "SomeHost.com")
      expect(decorator.headers_list).to eq(["HTTP/1.1 SomeHost.com", "Key1: Value1"])
    end
  end

  describe "#headers_with_body" do
    it "creates a string array containing header lines along with body" do
      allow(model).to receive(:headers).and_return(nil)
      allow(model).to receive(:body).and_return(nil)
      expect(decorator.headers_with_body).to eq([])

      allow(model).to receive(:headers).and_return("Version" => "HTTP/1.1", "Key1" => "Value1", "Host" => "SomeHost.com")
      allow(model).to receive(:body).and_return(nil)
      expect(decorator.headers_with_body).to eq(["HTTP/1.1 SomeHost.com", "Key1: Value1"])

      allow(model).to receive(:headers).and_return({})
      allow(model).to receive(:body).and_return("whatever")
      expect(decorator.headers_with_body).to eq(["whatever"])

      allow(model).to receive(:body).and_return("whatever")
      allow(model).to receive(:headers).and_return("Version" => "HTTP/1.1", "Key1" => "Value1", "Host" => "SomeHost.com")
      expect(decorator.headers_with_body).to eq(["HTTP/1.1 SomeHost.com", "Key1: Value1", "", "", "whatever"])
    end
  end

end
