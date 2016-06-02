class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  serialization_scope :view_context

  def self.set_pagination_headers(name, options = {})
    after_filter(options) do |controller|
      results = instance_variable_get("@#{name}")

      headers['X-Pagination'] = {
        total: results.total_count,
        total_pages: results.total_pages,
        first_page: results.current_page == 1,
        last_page: results.last_page?,
        previous_page: results.prev_page,
        next_page: results.next_page,
        out_of_bounds: results.out_of_range?,
        offset: results.offset_value
      }.to_json
    end
  end
end
