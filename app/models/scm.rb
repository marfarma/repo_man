class Scm
  SUPPORTED_SCM = %w(svn git)

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

  def self.move(scm_type, old_slug, new_slug)
    system "sudo /bin/mv #{Scm.path_to(scm_type, old_slug)} #{Scm.path_to(scm_type, new_slug)}"
  end

  def self.delete(scm_type, slug)
    system "sudo /bin/rm -rf #{Scm.path_to(scm_type, slug)}"
  end
  
  def self.path_to(scm_type, slug)
    case scm_type
    when 'svn'
      "/srv/svn/#{slug}"
    when 'git'
      "/srv/git/#{slug}.git"
    end
  end
end