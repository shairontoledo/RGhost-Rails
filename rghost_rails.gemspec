# shairon.toledo@gmail.com
# May 18 2009
#
require 'rubygems'

spec = Gem::Specification.new do |s|
  s.name      = "rghost_rails"
  s.version = "0.3"
  s.author    = "Shairon Toledo"
  s.email     = "shairon.toledo@gmail.com"
  s.homepage = "http://github.com/shairontoledo/RGhost-Rails"
  s.platform = Gem::Platform::RUBY
  s.rubyforge_project="An Rails adapter to work with RGhost in the view layer"
  s.summary = "An Rails adapter to work with RGhost in the view layer"
  candidates = ['lib/rghost_rails.rb']
  s.files     = candidates
  s.require_path      = "lib" 
  s.add_dependency('rghost', [">= 0.8.7"])

end
if $0 == __FILE__
      Gem::manage_gems
      Gem::Builder.new(spec).build
end
