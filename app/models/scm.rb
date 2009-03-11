class Scm
  attr_reader :location
  
  def initialize(scm_type, path)
    case scm_type
    when 'svn'
      if !File.exist?("/srv/svn/#{path}") && system("sudo /usr/local/bin/svn-o-mat.sh #{path}")
        @location = "svn://svn.lab.viget.com/#{path}/trunk"
      end
    when 'git'
      if !File.exist?("/srv/git/#{path}.git") && system("sudo /usr/local/bin/git-o-mat.sh #{path}")
        @location = "git.lab.viget.com:/srv/git/#{path}.git"
      end
    end
  end
end