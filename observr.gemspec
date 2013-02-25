require File.expand_path('../lib/observr/version', __FILE__)

Gem::Specification.new do |s|
  s.name                = "observr"
  s.summary             = "Watch files in a directory and do an action when they change"
  s.description         = "Watch files in a directory and take some action when they change (run tests, compile markdown, compile SCSS, etc)"
  s.authors             = ["mynyml", "kevinburke"]
  s.email               = "kev+watchr@inburke.com"
  s.homepage            = "https://github.com/kevinburke/observr"
  s.require_path        = "lib"
  s.bindir              = "bin"
  s.license             = "MIT"
  s.executables         = "observr"
  s.version             =  Observr::VERSION
  s.files               =  `git ls-files`.strip.split("\n")

  s.add_development_dependency 'minitest'
  s.add_development_dependency 'mocha'
  s.add_development_dependency 'every'
end
