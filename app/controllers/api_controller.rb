class ApiController < ApplicationController
  caches_page :index
  def index
    render :layout => false
  end
end
