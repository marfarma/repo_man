class Scm
  SUPPORTED_SCM = %w(svn git)

  def self.create(scm_type, path)
    case scm_type
    when 'svn'
      !File.exist?("/srv/svn/#{path}") && system("sudo /usr/local/bin/svn-o-mat.sh #{path}")
    when 'git'
      !File.exist?("/srv/git/#{path}.git") && system("sudo /usr/local/bin/git-o-mat.sh #{path}")
    end
  end

  def self.move(scm_type, old_slug, new_slug)
    system "sudo /bin/mv #{Scm.path_to(scm_type, old_slug)} #{Scm.path_to(scm_type, new_slug)}"
  end

  def self.delete(scm_type, slug)
    system "sudo /bin/rm -rf #{Scm.path_to(scm_type, slug)}"
  end
  
  def self.url_for(scm_type, slug)
    case scm_type
    when 'svn'
      "svn://svn.lab.viget.com/#{slug}/trunk"
    when 'git'
      "git.lab.viget.com:/srv/git/#{slug}.git"
    end
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