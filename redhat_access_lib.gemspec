Gem::Specification.new do |s|
  s.name = 'redhat_access_lib'
  s.version = '1.0.3'
  s.date = '2015-03-11'
  s.summary = "Rest Client for accessing Red Hat Support"
  s.description = "Rest Client for accessing Red Hat Support"
  s.authors = ["Lindani Phiri", "Rex White", "Ian Page Hands"]
  s.email = 'lphiri@redhat.com'
  s.files = Dir['lib/**/*'] + ["redhat_access_lib.gemspec", "Rakefile"]
  s.homepage ='http://rubygems.org/gems/redhat_support_lib'
  s.license = 'MIT'

  s.add_runtime_dependency 'rest-client'
  s.add_development_dependency 'rake'

end
