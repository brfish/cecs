local Entity = class("cecs_entity")

function Entity:initialize()
	self.alive = true
end

function Entity:isAlive()
	return self.alive
end

function Entity:kill()
	self.alive = false
end

function Entity:addComponent(componentName, component)
	if self[componentName] == nil then
		self[componentName] = component
		return true
	else
		error("Could not add the component to the entity: The component has existed")
	end
end

function Entity:removeComponent(componentName)
	if self[componentName] then
		self[componentName] = nil
		return true
	end
	return false
end

function Entity:__tostring()
	return string.format("Entity Object[%s]", self.class.name)
end

return Entity