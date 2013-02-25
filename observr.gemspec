require 'lib/observr'

Gem::Specification.new do |s|
  s.name                = "observr"
  s.summary             = "Modern continuous testing (flexible alternative to autotest)"
  s.description         = "Modern continuous testing (flexible alternative to autotest)."
  s.author              = "mynyml"
  s.email               = "mynyml@gmail.com"
  s.homepage            = "http://mynyml.com/ruby/flexible-continuous-testing"
  s.rubyforge_project   = "observr"
  s.require_path        = "lib"
  s.bindir              = "bin"
  s.executables         = "observr"
  s.version             =  Observr::VERSION
  s.files               =  `git ls-files`.strip.split("\n")

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'every'
end
