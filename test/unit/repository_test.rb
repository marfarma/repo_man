require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  should_validate_presence_of :name, :path
  should_allow_values_for     :scm, 'git', 'svn'
  should_not_allow_values_for :scm, 'cvs', 'sourcesafe'

  context 'the Repsitory model' do
    should 'default to ordering by name ASC' do
      assert_equal 'name ASC', Repository.default_scoping.first[:find][:order]
    end
  end

  context 'a Repository object' do
    should 'fill in path on creation if it is not provided' do
      @repository = Factory(:repository)
      assert_equal @repository.name.to_s.parameterize.to_s, @repository.path
    end
    should 'not change path on creation if it is provided' do
      @repository = Factory(:repository, :path => 'smarty_pants')
      assert_equal 'smarty_pants', @repository.path
    end
  end
end
