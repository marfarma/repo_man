class Scm
  attr_reader :location
  
  def initialize(scm_type, path)
    case scm_type
    when 'svn'
      if system("sudo /usr/local/bin/svn-o-mat.sh #{path}")
        @location = "svn://svn.lab.viget.com/#{path}/trunk"
      end
    when 'git'
      if system("sudo /usr/local/bin/git-o-mat.sh #{path}")
        @location = "git.lab.viget.com:/srv/git/#{path}.git"
      end
    end
  end
end