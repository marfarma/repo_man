class Repository < ActiveRecord::Base
  SUPPORTED_SCM = %w(svn git)
  
  default_scope :order => 'name ASC'

  validates_presence_of :name, :path
  validates_uniqueness_of :path
  validates_inclusion_of :scm, :in => SUPPORTED_SCM, :message => 'is invalid'
  
  before_validation :fill_in_path
  
  def fill_in_path
    self.path = self.name.to_s.parameterize.to_s if self.path.blank?
  end
end
