RSpec.feature "User authentication", type: :feature do

  scenario "user should be able to register" do
    visit root_path
    click_link 'Register'
    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password", exact: true
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"

    expect(page).to have_content "activate your account"
    expect(User.find_by(email: "newuser@example.com")).to be_persisted
  end

  scenario "user should be able to log in" do
    user = create(:confirmed_user)

    visit root_path
    click_link 'Log in'
    fill_in "Email", with: user.email
    fill_in "Password", with: "password"
    click_button "Log in"

    expect(page).to have_link "Profile"
    expect(page.current_path).to eq root_path
    expect(page).to have_content "Signed in successfully"
  end

  scenario "user logins with wrong credentials" do
    user = create(:confirmed_user)

    visit root_path
    click_link 'Log in'
    fill_in "Email", with: user.email
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"

    expect(page).to have_content "Invalid email or password"
    expect(page.current_path).to eq new_user_session_path
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
