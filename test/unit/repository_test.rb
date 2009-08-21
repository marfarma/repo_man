require 'test_helper'

class RepositoryTest < ActiveSupport::TestCase
  context 'the Repsitory model' do
    should 'default to ordering by name ASC' do
      assert_equal 'name ASC', Repository.default_scoping.first[:find][:order]
    end
  end

  context 'a Repository object' do
    setup do
      Scm.stubs(:create).returns(true)
    end
    should_allow_mass_assignment_of     :name, :scm
    should_not_allow_mass_assignment_of :path
    should_validate_presence_of         :name
    Scm::SUPPORTED_SCM.each { |s| should_allow_values_for :scm, s }
    should_not_allow_values_for         :scm, 'cvs', 'sourcesafe'
  end

  context 'a specific Repository object' do
    setup do
      Scm.stubs(:create).returns(true)
      @repository = Factory(:repository)
    end
    subject { @repository }
    should_validate_uniqueness_of :path
    should 'have a slug' do
      @repository = Factory(:repository)
      assert_equal @repository.name.to_s.parameterize.to_s, @repository.slug
    end
  end

  context 'interacting with Scm to manipulate repositories on disk' do
    should 'permit Repository object to be saved if Scm.create succeeds' do
      Scm.expects(:create).returns(stub(:location => 'pass'))
      @repository = Factory.build(:repository, :scm => 'svn', :path => 'path')
      assert @repository.save
    end
    should 'not permit Repository object to be saved if Scm.create fails' do
      Scm.expects(:create).returns(false)
      @repository = Factory.build(:repository, :scm => 'svn', :path => 'path')
      assert !@repository.save
      assert @repository.errors.on(:base)
    end
    should "rename repository on disk when repository object's name is changed" do
      Scm.expects(:create).returns(stub(:location => 'pass'))
      @repository = Factory(:repository, :scm => 'svn', :path => 'path')
      Scm.expects(:move).with('svn', @repository.slug, 'pants').returns(true)
      @repository.update_attributes(:name => 'pants')
      assert_equal Scm.url_for('svn', 'pants'), @repository.path
    end
    should "fail validation when repository object's scm is changed" do
      Scm.expects(:create).returns(stub(:location => 'pass'))
      @repository = Factory(:repository, :scm => 'svn', :path => 'path')
      @repository.scm = 'git'
      assert !@repository.save
      assert @repository.errors.on(:scm)
    end
    should 'destroy repository on disk when repository object is deleted' do
      Scm.expects(:create).returns(stub(:location => 'pass'))
      @repository = Factory(:repository, :scm => 'svn', :path => 'path')
      Scm.expects(:delete).with('svn', @repository.slug).returns(true)
      @repository.destroy
    end
  end
end
