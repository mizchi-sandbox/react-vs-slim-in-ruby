require 'v8'
require 'json'
require 'oj'

$react_source = File.read("./node_modules/react/dist/react.min.js")
class ReactRenderer
  def initialize
    @ctx = V8::Context.new
    @ctx.eval """
      var global = {};
    """
    @ctx.eval $react_source
    @ctx.eval """
      var React = global.React;
    """
  end

  def register name, template
    template.sub! "module.exports", "var #{name}"
    @ctx.eval template
  end

  def render name, props
    @ctx.eval """
      React.renderToString(#{name}(#{Oj.dump(props, :mode => :compat)}))
    """
  end
end

r = ReactRenderer.new
r.register "foo", File.read('templates/foo.js')

# benchmark
require "time"
start = Time.now.to_f
N = 100000
N.times do
  r.render("foo", {name: "Hoge", items: [1, 3, 4]})
end
ret = Time.now.to_f - start
p ret
p ret/N
