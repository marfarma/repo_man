class Scm
  SUPPORTED_SCM = %w(git svn)

  def self.create(scm_type, path)
    case scm_type
    when 'svn'
      !File.exist?("#{SITE['svn_root']}/#{path}") && system("sudo #{SITE['svn_script']} #{path}")
    when 'git'
      !File.exist?("#{SITE['git_root']}/#{path}.git") && system("sudo #{SITE['git_script']} #{path}")
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
      "svn://#{SITE['svn_host']}/#{slug}/trunk"
    when 'git'
      "#{SITE['git_host']}:#{SITE['git_root']}/#{slug}.git"
    end
  end

  def self.path_to(scm_type, slug)
    case scm_type
    when 'svn'
      "#{SITE['svn_root']}/#{slug}"
    when 'git'
      "#{SITE['git_root']}/#{slug}.git"
    end
  end
end