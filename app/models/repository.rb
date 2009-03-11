class Repository < ActiveRecord::Base
  SUPPORTED_SCM = %w(svn git)

  default_scope :order => 'name ASC'

  validates_presence_of :name
  validates_uniqueness_of :path, :allow_blank => true
  validates_inclusion_of :scm, :in => SUPPORTED_SCM, :message => 'is invalid'

  before_validation :create_scm_repository

  def create_scm_repository
    unless self.name.blank?
      if location = Scm.new(self.scm, self.name.to_s.parameterize.to_s).location
        self.path = location
      else
        self.errors.add_to_base('Repository could not be created. It happens sometimes. People just explode. Natural causes.')
        false
      end
    end
  end
end
