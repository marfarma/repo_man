require 'test_helper'

class ApiControllerTest < ActionController::TestCase
  context 'GET to :index' do
    setup do
      get :index
    end
    should_respond_with :success
    should_render_template :index
    should_render_with_layout false
  end
end
