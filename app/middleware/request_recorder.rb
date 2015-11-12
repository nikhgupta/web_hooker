class RequestRecorder
  def initialize(app, options = {})
    @app = app
    @options = options
  end

  def call(env)
    @env, portal = env, portal_for(env['PATH_INFO'])

    if portal.present?
      submission = create_submission_request_via(portal)
      env['HTTP_X_WEBHOOKER_FOR'] = env['HTTP_HOST']
      env['HTTP_X_WEBHOOKER_SUBMISSION_ID'] = submission.id
    end

    @app.call env
  end

  private

  def portal_for(path)
    path = path.dup.gsub!(@options[:path_prefix], '')
    Portal.find_by(slug: path) if path
  end

  def create_submission_request_via(portal)
    @request = Rack::Request.new(@env)
    portal.submissions.create(
      ip: sender_ip,
      host: @env['HTTP_HOST'],
      uuid: @env['action_dispatch.request_id'] || SecureRandom.uuid,
      headers: @request.incoming_headers(:http, :content),
      body: @request.body.string,
      request_method: @request.request_method.to_s.underscore,
      content_type: @request.content_type,
      content_length: @request.content_length.to_i
    )
  end

  def sender_ip
    @env['HTTP_X_REAL_IP'] || @env['HTTP_FORWARDED_FOR'] || @env['HTTP_HOST']
  end
end

