local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local CEntityManager = class("cecs_entitymanager")

function CEntityManager:init()
	self.entities = {}

	self.point = 0
	self.size = 0
end

function CEntityManager:contains(entity)
	if entity.id == -1 then
		return false
	end
	return self.entities[entity.id] ~= nil
end

function CEntityManager:addEntity(entity)
	if self.entities[entity.id] then
		error("Fail to add entity to entity manager: the entity has existed")
		return
	end
	self.point = self.point + 1
	self.size = self.size + 1
	local id = self.point
	entity.id = id
	self.entities[id] = entity
end

function CEntityManager:removeEntity(entity)
	if entitiy.id == -1 or self.entities[entity.id] == nil then
		error("Fail to remove entity from entity manager: the entity is not existed")
		return
	end
	self.size = self.size - 1
	self.entities[entity.id] = nil
end

function CEntityManager:clear()
	self.entities = {}
	self.point = 0
	self.size = 0
end

function CEntityManager:getByEntityID(id)
	if self.entities[id] then
		return self.entities[id]
	end
end

function CEntityManager:getAllEntities()
	return self.entities
end

return CEntityManager