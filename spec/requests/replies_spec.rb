RSpec.describe "Replies", type: :request do
  describe "GET /replies" do
    it "requires authentication" do
      get replies_path
      expect(response).to have_http_status(302)
      expect(response).to be_redirect
    end

    it "does not redirect if user is logged in" do
      login_as create(:confirmed_user)
      get replies_path
      expect(response).to have_http_status(200)
      expect(response).not_to be_redirect
    end
  end
end
