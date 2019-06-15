require("cecs")

pos = cecs.Component.new(function(x, y)
	return {x = x, y = y}
end)

speed = cec.Component.new(function(x, y)
	return {x = x, y = y}
end)

circle = cecs.Entity.new()
circle:addComponent(pos, 50, 50)


render = cecs.System.new()
function render:update(dt)
	local entities = self:getEntities()
	local it = entities:iterator()
	while it:next() do
		local e = it:get()
		love.graphics.circle("fill", e.x, e.y, 25)
	end
end

aworld = cecs.World.new()
aworld:addSystem(render)
aworld:addEntity(circle)

function love.load()
end

function love.update(dt)
	aworld:update(dt)
end