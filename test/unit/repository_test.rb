require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  context 'the Repsitory model' do
    should 'default to ordering by name ASC' do
      assert_equal 'name ASC', Repository.default_scoping.first[:find][:order]
    end
  end

  context 'a Repository object' do
    setup do
      Scm.stubs(:new).returns(stub(:location => 'pass'))
      @repository = Factory(:repository)
    end
    should_validate_presence_of    :name
    should_not_allow_values_for    :scm, 'cvs', 'sourcesafe'
    Repository::SUPPORTED_SCM.each { |s| should_allow_values_for :scm, s }
    should_validate_uniqueness_of :path
    should 'have a slug' do
      assert_equal @repository.name.to_s.parameterize.to_s, @repository.slug
    end
  end

  context 'interacting with Scm to create repositories on disk' do
    should 'permit Repository object to be saved if Scm.new succeeds' do
      Scm.expects(:new).returns(stub(:location => 'pass'))
      @repository = Factory.build(:repository, :scm => 'svn', :path => 'path')
      assert @repository.save
    end
    should 'not permit Repository object to be saved if Scm.new fails' do
      Scm.expects(:new).returns(stub(:location => nil))
      @repository = Factory.build(:repository, :scm => 'svn', :path => 'path')
      assert !@repository.save
      assert @repository.errors.on(:base)
    end
    should 'destroy repository on disk when repository object is deleted' do
      Scm.expects(:new).returns(stub(:location => 'pass'))
      Scm.expects(:delete).returns(true)
      @repository = Factory(:repository, :scm => 'svn', :path => 'path')
      @repository.destroy
    end
  end
end
