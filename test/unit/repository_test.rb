require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  should_validate_presence_of :name
  should_allow_values_for     :scm, 'git', 'svn'
  should_not_allow_values_for :scm, 'cvs', 'sourcesafe'

  should 'default to ordering by name ASC' do
    assert_equal 'name ASC', Repository.default_scoping.first[:find][:order]
  end
end
