require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  should_validate_presence_of    :name, :path
  should_not_allow_values_for    :scm, 'cvs', 'sourcesafe'
  Repository::SUPPORTED_SCM.each { |s| should_allow_values_for :scm, s }

  context 'the Repsitory model' do
    should 'default to ordering by name ASC' do
      assert_equal 'name ASC', Repository.default_scoping.first[:find][:order]
    end
  end

  context 'a Repository object' do
    setup do
      @repository = Factory(:repository)
    end
    
    should_validate_uniqueness_of :path

    should 'fill in path on creation if it is not provided' do
      assert_equal @repository.name.to_s.parameterize.to_s, @repository.path
    end

    should 'not change path on creation if it is provided' do
      @repository = Factory(:repository, :path => 'smarty_pants')
      assert_equal 'smarty_pants', @repository.path
    end
  end
end
