RSpec.configure do |config|

  config.include TestHelpers
  config.include FactoryGirl::Syntax::Methods
  config.include ActiveSupport::Testing::TimeHelpers
  config.include ActiveJob::TestHelper, type: :job
  config.include IntegrationHelpers, type: :feature
  config.include Warden::Test::Helpers, type: :request
  config.include Capybara::RSpecMatchers, type: :decorator

  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    begin
      DatabaseCleaner.start
      FactoryGirl.lint
    ensure
      DatabaseCleaner.clean_with(:truncation)
    end
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after(:each) do
    travel_back
  end

  config.around(:each, type: :request) do |example|
    Warden.test_mode!
    example.run
    Warden.test_reset!
  end
end


