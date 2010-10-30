Gem::Specification.new do |s|
  s.name	= "justinlynn-gchart"
  s.version	= "0.0.1"
  s.platform	= Gem::Platform::RUBY
  s.authors	= ["Original GChart Contributors", "Justin Lynn"]
  s.email	= ["justinlynn@gmail.com"]
  s.homepage	= "http://github.com/justinlynn/gchart"
  s.summary	= "A library for generating Google Chart API urls"

  s.required_rubygems_version	= ">= 1.3.6"

  s.files	= Dir.glob("{bin,lib}/**/*") + %w(README.txt CHANGELOG.txt)
  s.require_path = 'lib'
end
