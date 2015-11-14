module IntegrationHelpers
  def test_server
    "#{Capybara.server_host}:#{Capybara.server_port}"
  end

  def devel_server
    "#{ENV['DEVEL_SERVER_HOST']}:#{ENV['DEVEL_SERVER_PORT']}"
  end
  def show_page
    save_page Rails.root.join('public', 'capybara.html')
    %x(launchy http://#{devel_server}/capybara.html)
  end

  def login_as(user, password = "password")
    visit root_path
    logout

    click_link 'Log in'
    fill_in "Email", with: user.email
    fill_in "Password", with: password
    click_button "Log in"
    user
  end

  def logout
    click_link 'Log out' if page.has_link?("Log out")
  end
end
