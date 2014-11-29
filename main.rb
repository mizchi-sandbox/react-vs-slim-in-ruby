require 'v8'
$react_source = open("./node_modules/react/dist/react.min.js").read

class ReactContext
  def initialize(ctx)
    @ctx = ctx
  end

  def render(props)
    @ctx.eval """
      global.React.renderToString(global.React.createElement('div'))
    """
  end
end

def create_react_context
  ctx = V8::Context.new
  ctx.eval """
    var global = {};
  """
  ctx.eval $react_source
  ReactContext.new ctx
end

ctx = create_react_context()
p ctx.render({})
