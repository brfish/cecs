local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "class")
local Types = require(BASEDIR .. "type_info")

local JuSystem = class("juice_system")

function JuSystem:init(filters, rejects)
	self.__isSystem = true
	
	self.world = nil
	self.eventManager = nil

	self.entities = {}
	self.filters = filters or {}
	self.rejects = rejects or {}

	self.active = true
end

function JuSystem:setWorld(world)
	if not Types.isWorld(world) then
		Types.error(world, "world")
	end
	if world then
		self.world = world
		return
	end
	self.world = nil
end

function JuSystem:setEventManager(manager)
	if not Types.isEventManager(manager) then
		Types.error(manager, "eventmanager")
	end
	self.eventManager = manager or nil
end

function JuSystem:setFilters(filters)
	self.filters = filters
end

function JuSystem:addFilter(filter)
	for i = 1, #self.filters do
		if self.filters[i] == filter then
			error("Fail to add filter to system: the filter has existed")
			return
		end
	end
	self.filters[#self.filters + 1] = filter
end

function JuSystem:removeFilter(filter)
	for i = #self.filters, 1, -1 do
		if self.filters[i] == filter then
			table.remove(self.filters, i)
			return true
		end
	end
	return false
end

function JuSystem:addEntity(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	self.entities[entity.id] = entity
end

function JuSystem:removeEntity(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	self.entities[entity.id] = nil
end

function JuSystem:eligible(entity)
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

function JuSystem:getEntities()
	return self.entities
end

function JuSystem:foreach(update)
	if not update or type(update) ~= "function" then
		return
	end
	for _, entity in pairs(self.entities) do
		if entity.active then
			update(entity)
		end
	end
end

function JuSystem:clearEntities()
	self.entities = {}
end

function JuSystem:activate()
	self.active = true
end

function JuSystem:deactivate()
	self.active = false
end

function JuSystem:isActive()
	return self.active
end

return JuSystem