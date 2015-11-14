class HttpMethodNotAllowed
  def initialize(app)
    @app = app
  end

  def call(env)
    supported_methods = ActionDispatch::Request::HTTP_METHODS
    requested_method  = env["REQUEST_METHOD"].parameterize.upcase

    if supported_methods.include?(requested_method)
      @app.call env
    else
      Rails.logger.info("ActionController::UnknownHttpMethod: #{env.inspect}")
      [405, {"Content-Type" => "text/plain"}, []]
    end
  end
end
