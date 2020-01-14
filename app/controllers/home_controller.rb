class HomeController < ApplicationController
  skip_after_action :verify_policy_scoped

  def index
  end

  def terms
  end

  def privacy
  end
end
