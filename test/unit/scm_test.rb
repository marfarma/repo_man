require 'test_helper'

class ScmTest < ActiveSupport::TestCase

  def mock_sudo_invocation_should_return(success)
    Scm.any_instance.expects(:system).returns(success)
  end

  context 'a new Scm object being initialized' do
    context 'with svn scm_type' do
      context 'if svn-o-mat succeeds' do
        setup do
          mock_sudo_invocation_should_return true
        end

        should 'return svn location' do
          assert_equal "svn://svn.lab.viget.com/awesome/trunk", Scm.new('svn', 'awesome').location
        end
      end

      context 'if svn-o-mat fails' do
        setup do
          mock_sudo_invocation_should_return false
        end

        should 'return nil' do
          assert_nil Scm.new('svn', 'awesome').location
        end
      end
    end

    context 'with git scm_type' do
      context 'if git-o-mat succeeds' do
        setup do
          mock_sudo_invocation_should_return true
        end

        should 'return git location' do
          assert_equal "git.lab.viget.com:/srv/git/awesome.git", Scm.new('git', 'awesome').location
        end
      end

      context 'if git-o-mat fails' do
        setup do
          mock_sudo_invocation_should_return false
        end

        should 'return nil' do
          assert_nil Scm.new('git', 'awesome').location
        end
      end
    end

    context 'with bogus scm_type' do
      should 'return nil' do
        assert_nil Scm.new('bogus', 'irrelevant').location
      end
    end
  end
end
