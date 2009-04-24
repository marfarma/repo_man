require 'test_helper'

class ScmTest < ActiveSupport::TestCase
  context 'creating a repository' do
    Scm::SUPPORTED_SCM.each do |scm|
      context "when scm type is #{scm}" do
        setup do
          @script = SITE["#{scm}_script"]
        end

        should "succeed if #{@script} succeeds" do
          File.expects(:exist?).with(Scm.path_to(scm, 'awesome')).returns(false)
          Scm.expects(:system).with("sudo #{@script} awesome").returns(true)
          assert Scm.create(scm, 'awesome')
        end

        should "fail if #{@script} fails" do
          File.expects(:exist?).with(Scm.path_to(scm, 'awesome')).returns(false)
          Scm.expects(:system).with("sudo #{@script} awesome").returns(false)
          assert !Scm.create(scm, 'awesome')
        end

        should 'fail if file exists' do
          File.expects(:exist?).with(Scm.path_to(scm, 'awesome')).returns(true)
          assert !Scm.create(scm, 'awesome')
        end
      end
    end

    should 'fail if scm type is not recognized' do
      assert !Scm.create('bogus', 'irrelevant')
    end
  end

  context 'moving a repository' do
    Scm::SUPPORTED_SCM.each do |scm|
      should "call /bin/mv via system when scm type is #{scm}" do
        Scm.expects(:system).with("sudo /bin/mv #{Scm.path_to(scm, 'old_slug')} #{Scm.path_to(scm, 'new_slug')}").returns(true)
        Scm.move(scm, 'old_slug', 'new_slug')
      end
    end
  end

  context 'removing a repository' do
    Scm::SUPPORTED_SCM.each do |scm|
      should "call /bin/rm via system when scm type is #{scm}" do
        Scm.expects(:system).with("sudo /bin/rm -rf #{Scm.path_to(scm, 'slug')}").returns(true)
        Scm.delete(scm, 'slug')
      end
    end
  end
end
