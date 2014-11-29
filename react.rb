require 'v8'
require 'json'

$react_source = open("./node_modules/react/dist/react.min.js").read
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
      React.renderToString(#{name}(#{props.to_json}))
    """
  end
end

r = ReactRenderer.new
r.register "foo", open('templates/foo.js').read

# benchmark
require "time"
start = Time.now.to_f
100000.times do
  r.render("foo", {name: "Hoge", items: [1, 3, 4]})
end
p Time.now.to_f - start
