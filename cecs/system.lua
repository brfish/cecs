local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "class")
local Types = require(BASEDIR .. "type_info")

local CSystem = class("cecs_system")

function CSystem:init(filters, rejects)
	self.__isSystem = true
	
	self.world = nil
	self.eventManager = nil

	self.entities = {}
	self.filters = filters or {}
	self.rejects = rejects or {}

	self.active = true
end

function CSystem:setWorld(world)
	if not Types.isWorld(world) then
		Types.error(world, "world")
	end
	if world then
		self.world = world
		return
	end
	self.world = nil
end

function CSystem:setEventManager(manager)
	if not Types.isEventManager(manager) then
		Types.error(manager, "eventmanager")
	end
	self.eventManager = manager or nil
end

function CSystem:setFilters(filters)
	self.filters = filters
end

function CSystem:addFilter(filter)
	for i = 1, #self.filters do
		if self.filters[i] == filter then
			error("Fail to add filter to system: the filter has existed")
			return
		end
	end
	self.filters[#self.filters + 1] = filter
end

function CSystem:removeFilter(filter)
	for i = #self.filters, 1, -1 do
		if self.filters[i] == filter then
			table.remove(self.filters, i)
			return true
		end
	end
	return false
end

function CSystem:addEntity(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	self.entities[entity.id] = entity
end

function CSystem:removeEntity(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	self.entities[entity.id] = nil
end

function CSystem:eligible(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	for i = 1, #self.filters do
		local filter = self.filters[i]
		if not entity:contains(filter) then
			return false
		end
	end
	return true
end

function CSystem:getEntities()
	return self.entities
end

function CSystem:foreach(update)
	if not update or type(update) ~= "function" then
		return
	end
	for _, entity in pairs(self.entities) do
		if entity.active then
			update(entity)
		end
	end
end

function CSystem:clearEntities()
	self.entities = {}
end

function CSystem:activate()
	self.active = true
end

function CSystem:deactivate()
	self.active = false
end

function CSystem:isActive()
	return self.active
end

return CSystem