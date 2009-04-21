class Repository < ActiveRecord::Base
  SUPPORTED_SCM = %w(svn git)

  default_scope :order => 'name ASC'

  validates_presence_of :name
  validates_uniqueness_of :path, :allow_blank => true
  validates_inclusion_of :scm, :in => SUPPORTED_SCM, :message => 'is invalid'

  before_create :create_scm_repository
  after_destroy :destroy_scm_repository

  def slug
    self.name.to_s.parameterize.to_s
  end

  def create_scm_repository
    if location = Scm.new(self.scm, self.slug).location
      self.path = location
    else
      self.errors.add_to_base('Repository could not be created. It happens sometimes. People just explode. Natural causes.')
      false
    end
  end

  def destroy_scm_repository
    Scm.delete(self.scm, self.slug)
  end
end
