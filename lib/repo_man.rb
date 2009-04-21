require 'rubygems'
require 'active_resource'

module RepoMan
  class Repository < ActiveResource::Base
    self.site = 'http://repoman.lab.viget.com/'
  end
end
