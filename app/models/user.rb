class User < ActiveRecord::Base
  include Clearance::User
  has_many :repositories, :dependent => :nullify
end
