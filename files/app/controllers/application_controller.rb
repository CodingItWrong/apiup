class ApplicationController < ActionController::Base
  include JSONAPI::ActsAsResourceController
  skip_before_action :verify_authenticity_token

  private

  def context
    {current_user: current_user}
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
