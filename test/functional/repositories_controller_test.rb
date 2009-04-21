require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  context 'with a previously-existing repository' do
    setup do
      Scm.stubs(:new).returns(stub(:location => 'pass'))
      @repository = Factory(:repository, :scm => 'git')
    end
    context 'GET to :index' do
      context 'with HTML format' do
        setup do
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
      context 'with XML format' do
        setup do
          get :index, :format => 'xml'
        end
        should_respond_with :success
        should_assign_to :repositories

        should 'render the repository' do
          assert_select 'repositories' do
            assert_select 'repository' do
              assert_select 'name', @repository.name
              assert_select 'path',  @repository.path
            end
          end
        end
      end
    end

    context 'GET to :show' do
      context 'with HTML format' do
        setup do
          get :show, :id => @repository.id
        end
        should_respond_with :success
        should_render_template :show
        should_assign_to :repository

        should 'render the repository' do
          assert_select 'h2', @repository.name
          assert_select 'p',  @repository.path
        end

        should 'render instructions' do
          assert_select 'div[class=instructions]'
        end

        should 'render a button to delete the repository' do
          assert_select 'form[method=post][action=?][class=button-to]', repository_path(@repository) do
            assert_select 'input[type=hidden][name=_method][value=delete]'
            assert_select 'input[type=submit][value=Delete this repository]'
          end
        end
      end
      context 'with XML format' do
        setup do
          get :show, :id => @repository.id, :format => 'xml'
        end
        should_respond_with :success
        should_assign_to :repository

        should 'render the repository' do
          assert_select 'repository' do
            assert_select 'name', @repository.name
            assert_select 'path',  @repository.path
          end
        end
      end
    end

    context 'DELETE to :destroy' do
      setup do
        Scm.expects(:system).returns(true)
      end
      context 'with HTML format' do
        setup do
          get :destroy, :id => @repository.id
        end
        should_change 'Repository.count', :by => -1
        should_set_the_flash_to "Repository deleted. Repo man is always intense!"
        should_respond_with :redirect
        should_redirect_to('the repository index') { repositories_url }
      end
      context 'with XML format' do
        setup do
          get :destroy, :id => @repository.id, :format => 'xml'
        end
        should_change 'Repository.count', :by => -1
        should_respond_with :ok
      end
    end
  end

  context 'GET to :new' do
    context 'with HTML format' do
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
    context 'with XML format' do
      setup do
        get :new, :format => 'xml'
      end
      should_respond_with :success
      should_assign_to :repository

      should 'render the repository schema' do
        assert_select 'repository' do
          assert_select 'name', nil
          assert_select 'path', nil
        end
      end
    end
  end

  context 'POST to :create' do
    context 'with valid parameters' do
      setup do
        Scm.stubs(:new).returns(stub(:location => 'pass'))
      end
      context 'with HTML format' do
        setup do
          post :create, :repository => Factory.attributes_for(:repository)
        end
        should_change 'Repository.count', :by => 1
        should_set_the_flash_to "Repository created. You know something? <strong>You're all right!</strong>"
        should_respond_with :redirect
        should_redirect_to('the repository') { repository_url(Repository.last.id) }
      end
      context 'with XML format' do
        setup do
          post :create, :repository => Factory.attributes_for(:repository), :format => 'xml'
        end
        should_change 'Repository.count', :by => 1
        should_respond_with :created
      end
    end
    context 'with invalid parameters' do
      context 'with HTML format' do
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
      context 'with XML format' do
        setup do
          post :create, :repository => { :name => nil }, :format => 'xml'
        end
        should_not_change 'Repository.count'
        should_respond_with :unprocessable_entity
      end
    end
  end
end
