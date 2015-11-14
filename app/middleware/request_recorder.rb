# Look inside:
# https://github.com/rails/rails/blob/master/actionpack/test/dispatch/request_test.rb
#
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
    @request = ActionDispatch::Request.new(@env)
    portal.submissions.create(
      host: @env['HTTP_HOST'],
      ip: @request.remote_ip,
      uuid: @request.uuid || SecureRandom.uuid,
      headers: @request.incoming_headers(:http, :content),
      body: request_body, payload: payload,
      request_method: @request.request_method.to_s.underscore,
      content_type: @request.content_type || @request.media_type,
      content_length: @request.content_length.to_i
    )
  end

  def request_body
    @request.env['rack.input'].try(:string) || @request.body.try(:string)
  end

  # TODO: Ensure that this does not raise errors.
  def payload
    Rack::Utils.parse_nested_query @request.env['QUERY_STRING'].to_s.strip
  end

  # def sender_ip
  #   @env['HTTP_X_REAL_IP'] || @env['HTTP_X_FORWARDED_FOR'] || @env['HTTP_HOST']
  # end
end

