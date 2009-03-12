require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  context 'GET to :index' do
    setup do
      Scm.stubs(:new).returns(stub(:location => 'pass'))
      @repository = Factory(:repository)
      get :index
    end
    should_respond_with :success
    should_render_template :index
    should_assign_to :repositories

    should 'render the repository' do
      assert_select 'h2', @repository.name
      assert_select 'p',  @repository.path
    end

    should 'render a link to create a new repository' do
      assert_select 'a[href=?]', new_repository_path
    end
  end

  context 'GET to :new' do
    setup do
      get :new
    end
    should_respond_with :success
    should_render_template :new
    should_assign_to :repository

    should 'have a form to create a repository' do
      assert_select 'form[action=?][method=post]', repositories_path do
        assert_select 'input[type=text][name=?]', 'repository[name]'
        assert_select 'select[name=?]', 'repository[scm]' do
          Repository::SUPPORTED_SCM.each { |s| assert_select "option[value=#{s}]", s }
        end
        assert_select 'input[type=submit]'
      end
    end
  end

  context 'POST to :create' do
    context 'with valid parameters' do
      setup do
        Scm.stubs(:new).returns(stub(:location => 'pass'))
        post :create, :repository => Factory.attributes_for(:repository)
      end
      should_change 'Repository.count', :by => 1
      should_set_the_flash_to "Repository created. You know something? <strong>You're all right!</strong>"
      should_respond_with :redirect
      should_redirect_to('the repository index') { repositories_url }
      should "store created repository's id in flash for possible further instructions" do
        assert_equal Repository.last.id, flash[:repository_id]
      end
    end
    context 'with invalid parameters' do
      setup do
        post :create, :repository => { :name => nil }
      end
      should_not_change 'Repository.count'
      should_not_set_the_flash
      should_respond_with :success
      should_render_template :new

      should 'render error messaging' do
        assert_select 'div[id=errorExplanation]' do
          assert_select 'p', "Errors! Try again. Repo Man's got all night, every night."
          assert_select 'p', "Fix these:"
          assert_select 'ul' do
            assert_select 'li', "Name can't be blank"
          end
        end
      end
    end
  end
end
