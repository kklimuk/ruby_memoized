# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruby_memoized/version'

Gem::Specification.new do |spec|
  spec.name          = 'ruby_memoized'
  spec.version       = RubyMemoized::VERSION
  spec.authors       = ['Kirill Klimuk']
  spec.email         = ['kklimuk@gmail.com']

  spec.summary       = %q{Memoize method return values even with different arguments.}
  spec.description   = <<-DESC.gsub(/\s\s+/, ' ')
RubyMemoized makes it easy to memoize methods, even if they have arguments or blocks, by making memoization as easy 
as declaring a method private.
  DESC
  spec.homepage      = 'https://github.com/kklimuk/memoized'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
