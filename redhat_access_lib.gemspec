Gem::Specification.new do |s|
  s.name = 'redhat_access_lib'
  s.version = '1.0.6'
  s.date = '2017-04-27'
  s.summary = "Rest Client for accessing Red Hat Support"
  s.description = "Rest Client for accessing Red Hat Support"
  s.authors = ["Lindani Phiri", "Rex White", "Ian Page Hands"]
  s.email = 'lphiri@redhat.com'
  s.files = Dir['lib/**/*'] + ["redhat_access_lib.gemspec", "Rakefile"]
  s.homepage ='http://rubygems.org/gems/redhat_support_lib'
  s.license = 'MIT'

  s.add_runtime_dependency 'rest-client', '~> 1.6', '>= 1.6.3'
  s.add_development_dependency 'rake'

end
