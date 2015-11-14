RSpec.shared_context "routing specs - stubbed devise authentication - verify rest routes" do
  let(:model){ described_class.name.underscore.gsub(/_controller$/, '') }
  let(:user) { instance_double(User) }
  let(:warden) do
    instance_double('Warden::Proxy').tap do |warden|
      allow(warden).to receive(:authenticate!).with(scope: :user)
        .and_return(authenticated?)
      allow(warden).to receive(:user).with(:user).and_return(user)
    end
  end

  def simulate_running_with_devise
    stub_const(
      'Rack::MockRequest::DEFAULT_ENV',
      Rack::MockRequest::DEFAULT_ENV.merge('warden' => warden),
    )
  end

  def routes_all_known_http_methods_to?(*args)
    ActionDispatch::Request::HTTP_METHODS.each do |method|
      expect(method.parameterize("-").upcase => path).to route_to(*args)
    end
  end

  before(:each){ simulate_running_with_devise }

  describe "rest routing" do
    context "with authenticated user" do
      let(:authenticated?) { true }
      it "routes to #index" do
        expect(:get => "/#{model}").to route_to("#{model}#index")
      end

      it "routes to #new" do
        expect(:get => "/#{model}/new").to route_to("#{model}#new")
      end

      it "routes to #show" do
        expect(:get => "/#{model}/1").to route_to("#{model}#show", :id => "1")
      end

      it "routes to #edit" do
        expect(:get => "/#{model}/1/edit").to route_to("#{model}#edit", :id => "1")
      end

      it "routes to #create" do
        expect(:post => "/#{model}").to route_to("#{model}#create")
      end

      it "routes to #update via PUT" do
        expect(:put => "/#{model}/1").to route_to("#{model}#update", :id => "1")
      end

      it "routes to #update via PATCH" do
        expect(:patch => "/#{model}/1").to route_to("#{model}#update", :id => "1")
      end

      it "routes to #destroy" do
        expect(:delete => "/#{model}/1").to route_to("#{model}#destroy", :id => "1")
      end

    end
    context "with unauthenticated user" do
      let(:authenticated?) { false }
      it "routes.not_to #index" do
        expect(:get => "/#{model}").not_to route_to("#{model}#index")
      end

      it "routes.not_to #new" do
        expect(:get => "/#{model}/new").not_to route_to("#{model}#new")
      end

      it "routes.not_to #show" do
        expect(:get => "/#{model}/1").not_to route_to("#{model}#show", :id => "1")
      end

      it "routes.not_to #edit" do
        expect(:get => "/#{model}/1/edit").not_to route_to("#{model}#edit", :id => "1")
      end

      it "routes.not_to #create" do
        expect(:post => "/#{model}").not_to route_to("#{model}#create")
      end

      it "routes.not_to #update via PUT" do
        expect(:put => "/#{model}/1").not_to route_to("#{model}#update", :id => "1")
      end

      it "routes.not_to #update via PATCH" do
        expect(:patch => "/#{model}/1").not_to route_to("#{model}#update", :id => "1")
      end

      it "routes.not_to #destroy" do
        expect(:delete => "/#{model}/1").not_to route_to("#{model}#destroy", :id => "1")
      end
    end
  end
end
