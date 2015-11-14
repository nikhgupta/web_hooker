require 'capybara/rspec'
require 'capybara/poltergeist'

Capybara.register_driver :poltergeist_custom do |app|
  Capybara::Poltergeist::Driver.new(
    app, inspector: false, timeout: 120, js_errors: true,
    phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']
  )
end

Capybara.run_server = true
Capybara.server_host = ENV['TEST_SERVER_HOST'] || "127.0.0.1"
Capybara.server_port = ENV['TEST_SERVER_PORT'] || 12010

Capybara.default_driver = :rack_test
Capybara.javascript_driver = :poltergeist_custom
Capybara.default_max_wait_time = 2
