local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local CEntity = class("cecs_entity")

local __NULL__ = {"__NULL__"}

function CEntity:init()
	self.entityManager = nil

	self.components = {}
	self.id = -1

	self.active = true
end

function CEntity:setManager(manager)
	self.entityManager = manager
end

function CEntity:addComponent(component, ...)
	if self.components[component] == nil then
		if #{...} == 0 then
			self.components[component] = __NULL__
		else
			self.components[component] = component:create(...)
		end
	else
		error("Could not add the component to the entity: The component has existed")
	end
end

function CEntity:removeComponent(component, ...)
	self.components[component] = nil
	for i = 1, #{...} do
		local c = select(i, ...)
		if self.components[c] then
			self.components[c] = nil
		end
	end
end

function CEntity:get(component)
	if self.components[component] then
		if self.components[component] == __NULL__ then
			return nil
		end
		if type(self.components[component]) ~= "table" then
			local value = self.components[component]
			self.components[component] = {value}
		end
		return self.components[component]
	end
end

function CEntity:getComponentsList()
	return self.components
end

function CEntity:contains(component)
	return self.components[component] ~= nil
end

function CEntity:activate()
	self.active = true
end

function CEntity:deactivate()
	self.active = false
end

return CEntity