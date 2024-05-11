class ApplicationController < ActionController::Base
  before_action :set_paper_trail_whodunnit

  alias_method :current_user, :current_admin
end
