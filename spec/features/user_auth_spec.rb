RSpec.feature "User authentication", type: :feature do

  # let(:account){ create :account, subdomain: "test" }
  # before(:each){ ActsAsTenant.current_tenant = account }
  # after(:each){ ActsAsTenant.current_tenant = nil }

  context "registration" do
    scenario "user should be able to register" do
      visit root_url
      click_link 'Register'
      fill_in "Account", with: "test"
      fill_in "Email", with: "newuser@example.com"
      fill_in "Password", with: "password", exact: true
      fill_in "Password confirmation", with: "password"
      click_button "Sign up"

      expect(page).to have_content "activate your account"
      expect(page.current_url).to eq new_user_session_url(subdomain: "test")
      user = User.find_by(email: "newuser@example.com")
      expect(user).to be_persisted
      expect(user.account).to be_persisted
      expect(user.account.subdomain).to eq "test"
    end
  end

  context "login" do
    scenario "user should be able to log in through main site and redirected properly" do
      user = create(:confirmed_user)

      visit root_url
      click_link 'Log in'
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      expect(page).to have_link "Profile"
      expect(page.current_url).to eq root_url(subdomain: "test")
      expect(page).to have_content "Signed in successfully"
    end
    scenario "user should be able to log in through his subdomain" do
      user = create(:confirmed_user)

      visit root_url(subdomain: "test")
      click_link 'Log in'
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      expect(page).to have_link "Profile"
      expect(page.current_url).to eq root_url(subdomain: "test")
      expect(page).to have_content "Signed in successfully"
    end
    scenario "user should not be able to log in through another subdomain" do
      user = create(:confirmed_user)

      visit root_url(subdomain: "another")
      click_link 'Log in'
      fill_in "Email", with: user.email
      fill_in "Password", with: "password"
      click_button "Log in"

      expect(page).not_to have_link "Profile"
      expect(page.current_url).to eq new_user_session_url(subdomain: "another")
      expect(page).not_to have_content "Signed in successfully"
    end
    scenario "user logins with wrong credentials" do
      user = create(:confirmed_user)

      visit root_url
      click_link 'Log in'
      fill_in "Email", with: user.email
      fill_in "Password", with: "wrongpassword"
      click_button "Log in"

      expect(page).to have_content "Invalid email or password"
      expect(page.current_url).to eq new_user_session_url
    end
  end

  context "logout" do
  end

  context "when user is logged in" do
    let(:user){ create :confirmed_user }
    before(:each) do
      login_as user
      visit root_path
    end

    scenario "user should be able to log out" do
      click_link 'Log out'
      expect(page).to have_link "Log in"
      expect(page).to have_content "Signed out successfully"
      expect(page.current_path).to eq root_path
    end

    scenario "user should be able to edit their profile" do
      click_link 'Profile'
      expect(page).to have_field 'Email', with: user.email
      expect(page).to have_field 'Password', exact: true
      expect(page).to have_field 'Password confirmation'
      expect(page).to have_field 'Current password'
    end
  end

  context "with admin user" do
    let(:user) { create :admin }
    before(:each) do
      login_as user
      visit root_path
    end

    scenario "user should be able to see Sidekiq dashboard" do
      expect(page).to have_link 'Monitor'
      expect{ visit monitor_path }.not_to raise_error
    end
  end

  context "with non-admin user" do
    let(:user) { create :confirmed_user }
    before(:each) do
      login_as user
      visit root_path
    end

    scenario "user should not be able to see Sidekiq dashboard" do
      expect(page).to have_no_link 'Monitor'
      expect{ visit monitor_path }.to raise_error(ActionController::RoutingError)
    end
  end

  context "with guests (not logged-in users)" do
    before(:each){ logout }
    scenario "user should not be able to see Sidekiq dashboard" do
      visit root_path
      expect(page).to have_no_link 'Monitor'

      visit monitor_path
      expect(page).to have_content "need to sign in"
      expect(page.current_path).to eq new_user_session_path
    end
  end
end
