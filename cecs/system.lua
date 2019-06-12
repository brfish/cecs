
local System = class("Cherry_cecs_System")

function System:initialize()
	self.alive = true
	self.active = true
end

function System:onAdd(entity)
end

function System:onRemove(entity)
end

function System:update(entityManager, dt)
end

function System:trigger(event)

end

function System:draw(entityManager, dt)
end

function System:isAlive()
	return self.alive
end

function System:kill()
	self.alive = false
end

function System:isActive()
	return self.active
end

function System:setActive(a)
	self.active = a
end

return System