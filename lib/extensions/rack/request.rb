class Rack::Request
  def incoming_headers(*args)
    headers = args.map do |arg|
      env.select do |key, val|
        key.start_with? "#{arg.to_s.upcase}_"
      end.collect do |key, val|
        key = key.sub(/^#{arg.to_s.upcase}_/, '') if arg.to_s.underscore.to_sym == :http
        [key, val]
      end.collect do |key, val|
        [key.split('_').collect(&:capitalize).join('-'), val]
      end.sort
    end.flatten(1)
    Hash[headers]
  end
end

