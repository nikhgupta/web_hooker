class RequestForwardingJob < ActiveJob::Base
  queue_as :high_priority

  def perform(sid, did)
    @submission, @destination = Submission.find(sid), Destination.find(did)
    measure_time_for{ forward_request }
    create_reply_for_destination
    @time_taken = @submission = @destination = @response = nil
  end

  private

  def measure_time_for(&block)
    start = Time.now
    yield
    @time_taken = Time.now - start
  end

  def forward_request
    @response = HTTParty.send @submission.request_method, @destination.url,
      body: @submission.body, headers: submission_headers,
      timeout: ENV['FORWARDED_REQUEST_TIMEOUT'].to_i
  rescue StandardError => e
    body = { error: "#{e.class}: #{e.message}" }.to_json
    @response = OpenStruct.new(
      code: 500, headers: {}, body: body,
      content_type: "application/json", content_length: body.length
    )
  end

  def create_reply_for_destination
    Reply.for(@submission, @destination).update_attributes(
      http_status_code: @response.code,
      content_type: @response.content_type,
      content_length: @response.content_length,
      headers: response_headers_for(@response),
      body: @response.body,
      response_time: @time_taken
    )
  end

  private

  def response_headers_for(response)
    Hash[response.headers.map{|k,v| [k, v.join("\n")]}]
  end

  def submission_headers
    headers = @submission.headers

    headers = headers.merge(
      "X-Webhooker-ID" => @submission.id,
      "X-Webhooker-For" => headers['Host'],
      "X-Webhooker-Request-ID" => @submission.uuid
    ).map{|key,val| [key, val.to_s]}

    Hash[headers].except("Host")
  end
end

