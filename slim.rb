require 'slim'
require "time"

r = Slim::Template.new('templates/foo.slim')

# benchmark
start = Time.now.to_f
100000.times do
  r.render(self, name: "foo", items: [1,2,3])
end
p Time.now.to_f - start
