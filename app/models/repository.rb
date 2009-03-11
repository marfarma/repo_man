class Repository < ActiveRecord::Base
  SUPPORTED_SCM = %w(svn git)

  default_scope :order => 'name ASC'

  validates_presence_of :name, :path
  validates_uniqueness_of :path
  validates_inclusion_of :scm, :in => SUPPORTED_SCM, :message => 'is invalid'

  before_validation :create_scm_repository

  def create_scm_repository
    if location = Scm.new(self.scm, self.name.to_s.parameterize.to_s).location
      self.path = location
    else
      false
    end
  end
end
