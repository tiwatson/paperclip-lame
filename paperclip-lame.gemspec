# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "paperclip-lame"
  s.version     = '0.1.1'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Tim Watson"]
  s.email       = ["tiwatson@gmail.com"]
  s.homepage    = "http://github.com/tiwatson/paperclip-lame"
  s.summary     = %q{Process your attachments with lame}
  s.description = %q{Process your attachments with lame}

  #s.rubyforge_project = "paperclip-lame"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  
  s.add_dependency('paperclip', '>=2.5.2')
end