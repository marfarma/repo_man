require 'test_helper'

class RepositoriesControllerTest < ActionController::TestCase
  context 'speaking HTML' do
    context 'in public, with a previously-existing repository' do
      setup do
        Scm.stubs(:create).returns(true)
        @repository = Factory(:repository)
      end

      context 'GET to :index' do
        setup do
          get :index
        end
        should_respond_with :success
        should_render_template :index
        should_assign_to :repositories

        should 'render the repository' do
          assert_select 'h2', "#{@repository.name} #{@repository.path}" do
            assert_select 'a[href=?]', repository_path(@repository), @repository.name
          end
        end

        should 'render a link to create a new repository' do
          assert_select 'a[href=?]', new_repository_path
        end

        should 'render The Repo Code' do
          assert_select 'div[class=instructions]'
        end

        should 'render a link to the API documentation' do
          assert_select 'p[id=api]'
        end
      end

      context 'GET to :show' do
        setup do
          get :show, :id => @repository.id
        end
        should_respond_with :success
        should_render_template :show
        should_assign_to :repository

        should 'render the repository' do
          assert_select 'h2', "#{@repository.name} #{@repository.path}" do
            assert_select 'a[href=?]', repository_path(@repository), @repository.name
          end
        end

        should 'render instructions' do
          assert_select 'div[class=instructions]'
        end

        should 'render a button to rename the repository' do
          assert_select 'a[href=?]', edit_repository_path(@repository), 'Rename this repository'
        end

        should 'render a button to delete the repository' do
          assert_select 'a[href=?]', repository_path(@repository), 'Delete this repository'
        end
      end
    end

    context 'with a user signed in' do
      setup do
        @user = Factory(:email_confirmed_user)
        sign_in_as @user
      end

      context 'who created a repository' do
        setup do
          Scm.stubs(:create).returns(true)
          @repository = Factory(:repository, :scm => 'git', :user => @user)
        end

        context 'GET to :edit' do
          setup do
            get :edit, :id => @repository.id
          end
          should_respond_with :success
          should_render_template :edit
          should_assign_to :repository

          should 'have a form to rename a repository' do
            assert_select 'form[action=?][method=post]', repository_path(@repository) do
              assert_select 'input[type=hidden][name=_method][value=put]'
              assert_select 'input[type=text][name=?]', 'repository[name]'
              assert_select 'a[href=#][onclick=?]', 'this.parentNode.parentNode.submit();; return false;', 'Create Repository'
            end
          end
        end

        context 'PUT to :update' do
          context 'with valid parameters' do
            setup do
              put :update, :id => @repository.id, :repository => Factory.attributes_for(:repository)
            end
            should_set_the_flash_to "Repository updated. You know something? <strong>You're all right!</strong>"
            should_respond_with :redirect
            should_redirect_to('the repository') { repository_url(@repository.id) }
          end
          context 'with invalid parameters' do
            setup do
              put :update, :id => @repository.id, :repository => { :name => nil }
            end
            should_not_set_the_flash
            should_respond_with :success
            should_render_template :edit

            should 'render error messaging' do
              assert_select 'div[id=errorExplanation]' do
                assert_select 'p', "Try again. Repo Man's got all night, every night."
                assert_select 'ul' do
                  assert_select 'li', "Name can't be blank"
                end
              end
            end
          end
        end

        context 'DELETE to :destroy' do
          setup do
            Scm.expects(:system).returns(true)
            get :destroy, :id => @repository.id
          end
          should_change 'Repository.count', :by => -1
          should_set_the_flash_to "Repository deleted. Repo man is always intense!"
          should_respond_with :redirect
          should_redirect_to('the repository index') { repositories_url }
        end
      end

      context 'who did not create a repository' do
        setup do
          Scm.stubs(:create).returns(true)
          @repository = Factory(:repository)
        end

        context 'GET to :edit' do
          setup do
            get :edit, :id => @repository.id
          end
          should_redirect_to('the front page') { root_url }
        end

        context 'PUT to :update' do
          setup do
            put :update, :id => @repository.id, :repository => {}
          end
          should_redirect_to('the front page') { root_url }
        end

        context 'DELETE to :destroy' do
          setup do
            delete :destroy, :id => @repository.id
          end
          should_redirect_to('the front page') { root_url }
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
              Scm::SUPPORTED_SCM.each { |s| assert_select "option[value=#{s}]", s }
            end
            assert_select 'a[href=#][onclick=?]', 'this.parentNode.parentNode.submit();; return false;', 'Create Repository'
          end
        end
      end

      context 'POST to :create' do
        context 'with valid parameters' do
          setup do
            Scm.stubs(:create).returns(true)
            post :create, :repository => Factory.attributes_for(:repository)
          end
          should_change 'Repository.count', :by => 1
          should_set_the_flash_to "Repository created. You know something? <strong>You're all right!</strong>"
          should_respond_with :redirect
          should_redirect_to('the repository') { repository_url(assigns(:repository)) }
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
              assert_select 'p', "Try again. Repo Man's got all night, every night."
              assert_select 'ul' do
                assert_select 'li', "Name can't be blank"
              end
            end
          end
        end
      end
    end

    context 'without a user signed in' do
      should_deny_access_on :get, :new
      should_deny_access_on :get, :edit, :id => 1
      should_deny_access_on :post, :create, :repository => Factory.attributes_for(:repository)
      should_deny_access_on :put, :update, :id => 1, :repository => Factory.attributes_for(:repository)
      should_deny_access_on :delete, :destroy, :id => 1
    end
  end

  # context 'speaking XML' do
  #   context 'with a previously-existing repository' do
  #     setup do
  #       Scm.stubs(:create).returns(true)
  #       @repository = Factory(:repository)
  #     end
  #     context 'GET to :index' do
  #       setup do
  #         get :index, :format => 'xml'
  #       end
  #       should_respond_with :success
  #       should_assign_to :repositories
  # 
  #       should 'render the repository' do
  #         assert_select 'repositories' do
  #           assert_select 'repository' do
  #             assert_select 'name', @repository.name
  #             assert_select 'path',  @repository.path
  #           end
  #         end
  #       end
  #     end
  # 
  #     context 'GET to :show' do
  #       setup do
  #         get :show, :id => @repository.id, :format => 'xml'
  #       end
  #       should_respond_with :success
  #       should_assign_to :repository
  # 
  #       should 'render the repository' do
  #         assert_select 'repository' do
  #           assert_select 'name', @repository.name
  #           assert_select 'path',  @repository.path
  #         end
  #       end
  #     end
  # 
  #     context 'PUT to :update' do
  #       context 'with valid parameters' do
  #         setup do
  #           put :update, :id => @repository.id, :repository => Factory.attributes_for(:repository), :format => 'xml'
  #         end
  #         should_respond_with :ok
  #       end
  #       context 'with invalid parameters' do
  #         setup do
  #           put :update, :id => @repository.id, :repository => { :name => nil }, :format => 'xml'
  #         end
  #         should_respond_with :unprocessable_entity
  #       end
  #     end
  # 
  #     context 'DELETE to :destroy' do
  #       setup do
  #         Scm.expects(:system).returns(true)
  #         get :destroy, :id => @repository.id, :format => 'xml'
  #       end
  #       should_change 'Repository.count', :by => -1
  #       should_respond_with :ok
  #     end
  #   end
  # 
  #   context 'GET to :new' do
  #     setup do
  #       get :new, :format => 'xml'
  #     end
  #     should_respond_with :success
  #     should_assign_to :repository
  # 
  #     should 'render the repository schema' do
  #       assert_select 'repository' do
  #         assert_select 'name', nil
  #         assert_select 'path', nil
  #       end
  #     end
  #   end
  # 
  #   context 'POST to :create' do
  #     context 'with valid parameters' do
  #       setup do
  #         Scm.stubs(:create).returns(true)
  #         post :create, :repository => Factory.attributes_for(:repository), :format => 'xml'
  #       end
  #       should_change 'Repository.count', :by => 1
  #       should_respond_with :created
  #     end
  #     context 'with invalid parameters' do
  #       setup do
  #         post :create, :repository => { :name => nil }, :format => 'xml'
  #       end
  #       should_not_change 'Repository.count'
  #       should_respond_with :unprocessable_entity
  #     end
  #   end
  # end
end