class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # set_current_tenant_by_subdomain(:account, :subdomain)
  set_current_tenant_through_filter
  prepend_before_filter :find_the_current_tenant
  before_filter :authenticate_user!

  private

  def find_the_current_tenant
    account = Account.find_by(subdomain: request.subdomain)
    # account = nil if current_user.present? && current_user.account != account
    set_current_tenant(account)
  end

  def after_sign_in_path_for(resource)
    root_path subdomain: resource.account.subdomain
  end
end
