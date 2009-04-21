spec = Gem::Specification.new do |s|
  s.name = 'repo_man'
  s.version = '1.0.0'
  s.author = 'Mark Cornick'
  s.email = 'mark@viget.com'
  s.homepage = 'http://repoman.lab.viget.com/'
  s.platform = Gem::Platform::RUBY
  s.summary = 'Repo Man API'
  s.files = ['lib/repo_man.rb']
  s.require_path = 'lib'
  s.has_rdoc = false
  s.add_dependency("activeresource", ">= 2.1.0")
end
