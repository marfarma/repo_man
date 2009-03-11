require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  context 'GET to :index' do
    setup do
      get :index
    end
    should_respond_with :success
    should_render_template :index
    should_assign_to :repositories
  end

  context 'GET to :show' do
    setup do
      @repository = Factory(:repository)
      get :show, :id => @repository.id
    end
    should_respond_with :success
    should_render_template :show
    should_assign_to :repository
  end

  context 'GET to :new' do
    setup do
      get :new
    end
    should_respond_with :success
    should_render_template :new
    should_assign_to :repository
  end

  context 'POST to :create' do
    context 'with valid parameters' do
      setup do
        post :create, :repository => Factory.attributes_for(:repository)
      end
      should_change "Repository.count", :by => 1
      should_set_the_flash_to 'The repository was successfully created.'
      should_respond_with :redirect
      should_redirect_to('the repository') { repository_url(assigns(:repository)) }
    end
    context 'with invalid parameters' do
      setup do
        post :create, :repository => { }
      end
      should_not_change "Repository.count"
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new
    end
  end
end
