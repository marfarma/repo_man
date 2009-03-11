class Repository < ActiveRecord::Base
  default_scope :order => 'name ASC'

  validates_presence_of :name
  validates_inclusion_of :scm, :in => %w(git svn), :message => 'is invalid'
end
