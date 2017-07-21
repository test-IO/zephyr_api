Gem::Specification.new do |s|
  s.name        = 'zephyr_api'
  s.version     = '0.0.0'
  s.date        = '2017-07-19'
  s.summary     = 'Wrap calls to Zephyr APIs'
  s.description = %w[Easily add authentication to your Zephyr Cloud API calls]
  s.authors     = ['Simon Lacroix']
  s.email       = 'simon@test.io'
  s.files       = ['lib/zephyr_api.rb', 'lib/zephyr_api/cloud_client.rb']
  # s.homepage    = 'http://rubygems.org/gems/zephyr_api'
  # s.license     = 'MIT'

  s.add_runtime_dependency 'jwt'
end
