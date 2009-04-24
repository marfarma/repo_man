class Repository < ActiveRecord::Base
  default_scope :order => 'name ASC'

  attr_accessible :name, :scm

  validates_presence_of :name
  validates_uniqueness_of :path, :allow_blank => true
  validates_inclusion_of :scm, :in => Scm::SUPPORTED_SCM, :message => 'is invalid'

  before_create :create_scm_repository
  validate_on_update :prevent_changing_scm
  before_update :move_scm_repository
  after_destroy :destroy_scm_repository

  def slug(base = self.name)
    base.to_s.parameterize.to_s
  end

  def create_scm_repository
    if Scm.create(self.scm, self.slug)
      self.path = Scm.url_for(self.scm, self.slug)
    else
      self.errors.add_to_base('Repository could not be created. It happens sometimes. People just explode. Natural causes.')
      false
    end
  end

  def prevent_changing_scm
    if self.scm_changed?
      self.errors.add(:scm, 'cannot be changed after creation')
    end
  end

  def move_scm_repository
    if self.name_changed?
      Scm.move(self.scm, self.slug(name_was), self.slug)
      self.path = Scm.url_for(self.scm, self.slug)
    end
  end

  def destroy_scm_repository
    Scm.delete(self.scm, self.slug)
  end
end
