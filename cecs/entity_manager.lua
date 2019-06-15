local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local CEntityManager = class("cecs_entitymanager")

function CEntityManager:init()
	self.entities = {}
	self.entityStamps = {}
end

function CEntityManager:contains(entity)
	return self.entityStamps[entity] ~= nil
end

function CEntityManager:addEntity(entity)
	if self.entityStamps[entity] == nil then
		self.entities[#self.entities + 1] = entity
		self.entityStamps[entity] = true
		local entityComponents = entity:getComponentsList()
		for i = 1, #entityComponents do
			local component = entityComponents[i]
			if self.subscribers[component] == nil then
				self.subscribers[component] = {}
			end
			self.subscribers[component][#self.subscribers[component] + 1] = entity
		end
	end
end

function CEntityManager:removeEntity(entity)
	for i = #self.entities, 1, -1 do
		if self.entities[i] == entity then
			table.remove(self.entities, i)
			self.entityStamps[entity] = nil 
			break
		end
	end
end

function CEntityManager:clear()
	for i = #self.entities, 1, -1 do
		local entity = self.entities[i]
		entity:destroy()
		table.remove(self.entities, i)
		self.entityStamps[entity] = nil
	end
end

return CEntityManager