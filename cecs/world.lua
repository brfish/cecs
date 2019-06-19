local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local ComponentsPool = require(BASEDIR .. "component").Pool

local EntityManager = require(BASEDIR .. "entity_manager")
local EventManager = require(BASEDIR .. "event_manager")

local BuiltinEvents = require(BASEDIR .. "builtin_events")

local CWorld = class("cecs_world")

function CWorld:init()
	self.componentsPool = ComponentsPool.new()

	self.entityManager = EntityManager.new()

	self.eventManager = EventManager.new()

	self.entityUpdateList = {}
	
	self.systems = {}
	self.systems.update = {point = 0, objects = {}, size = 0}
	self.systems.draw = {point = 0, objects = {}, size = 0}
	self.registeredSystems = {}

	self.eventManagerOptions = {
		event_entity_added_enable = false,
		event_entity_removed_enable = false,
		event_component_added_enable = false,
		event_component_removed_enable = false,
		event_system_added_enable = false,
		event_system_removed_enable = false
	}
end

function CWorld:setEntityManager(entityManager)
	self.entityManager = entityManager
end

function CWorld:setEventManager(eventManager)
	self.eventManager = eventManager
end

function CWorld:addEntity(entity)
	self.entityManager:addEntity(entity)

	entity:setManager(self.entityManager)

	if entity.update then
		self.entityUpdateList[#self.entityUpdateList + 1] = entity
	end
	for _, system in pairs(self.systems.update.objects) do
		if system:eligible(entity) then
			system:addEntity(entity)
			if self.eventManagerOptions.event_entity_added_enable then
				self.eventManager:queueEvent(
					BuiltinEvents.EVENT_ENTITY_ADDED(system, entity))
			end
		end
	end

	for _, system in pairs(self.systems.draw.objects) do
		if system:eligible(entity) then
			system:addEntity(entity)
			if self.eventManagerOptions.event_entity_added_enable then
				self.eventManager:queueEvent(
					BuiltinEvents.EVENT_ENTITY_ADDED(system, entity))
			end
		end
	end

	return entity
end

function CWorld:removeEntity(entity)

	self.entityManager:removeEntity(entity)

	if entity.update then
		for i = #self.entityUpdateList, 1, -1 do
			if self.entityUpdateList[i].id == entity.id then
				table.remove(self.entityUpdateList, i)
				break
			end
		end
	end

	for _, system in pairs(self.systems.update) do
		system:removeEntity(entity)
		if self.eventManagerOptions.event_entity_removed_enable then
				self.eventManager:queueEvent(
					BuiltinEvents.EVENT_ENTITY_REMOVED(system, entity))
		end
	end

	for _, system in pairs(self.systems.draw) do
		system:removeEntity(entity)
		if self.eventManagerOptions.event_entity_removed_enable then
				self.eventManager:queueEvent(
					BuiltinEvents.EVENT_ENTITY_REMOVED(system, entity))
		end
	end
end

function CWorld:addSystem(system, callback)

	local name = system.__cname
	if self.registeredSystems[name] then
		error("Fail to add system to the world: the system " .. name .. " has existed")
		return
	end

	if not system.update and not system.draw then
		error("Fail to add system to the world: the system is without 'update' or 'draw' function")
		return
	end

	system:setWorld(self)

	if callback == "update" then
		self.systems.update.point = self.systems.update.point + 1
		local point = self.systems.update.point
		self.systems.update.objects[point] = system
		self.registeredSystems[name] = {
			callback = "update", 
			index = point
		}
		self.systems.update.size = self.systems.update.size + 1
	end

	if callback == "draw" then
		self.systems.draw.point = self.systems.draw.point + 1
		local point = self.systems.draw.point
		self.systems.draw.objects[point] = system
		self.registeredSystems[name] = {
			callback = "draw", 
			index = point
		}
		self.systems.draw.size = self.systems.draw.size + 1
	end

	if self.eventManagerOptions.event_system_added_enable then
		self.eventManager:queueEvent(
			BuiltinEvents.EVENT_SYSTEM_ADDED(self, system))
	end

	local entities = self.entityManager:getAllEntities()
	for i = 1, #entities do
		local entity = entities[i]
		if system:eligible(entity) then
			system:addEntity(entity)
		end
	end

	return system
end

function CWorld:removeSystem(system)
	local name = system.__cname

	if not self.registeredSystems[name] then
		error("Fail to remove the system: the system is not existed")
		return
	end

	local callback, index = self.registeredSystems[name].callback, self.registeredSystems[name].index
	self.systems[callback].objects[index] = nil
	self.registeredSystems[name] = nil
	self.systems[callback].size = self.systems[callback].size - 1

	if self.eventManagerOptions.event_system_added_enable then
		self.eventManager:queueEvent(
			BuiltinEvents.EVENT_SYSTEM_REMOVED(self, system))
	end
end

function CWorld:stopSystem(system)
	local name = system.__cname

	if not self.registeredSystems[name] then
		error("Faile to stop the system: the system is not existed")
		return
	end

	system:deactivate()
end

function CWorld:startSystem(system)
	local name = system.__cname

	if not self.registeredSystems[name] then
		error("Faile to continue the system: the system is not existed")
		return
	end

	system:activate()
end

function CWorld:containsSystem(system)
	return self.registeredSystems[system] ~= nil
end

function CWorld:containsEntity(entity)
	return self.entityManager:contains(entity)
end

function CWorld:getAllEntities()
	return self.entityManager:getAllEntities()
end

function CWorld:update(dt)

	for i = 1, #self.entityUpdateList do
		local entity = self.entityUpdateList[i]
		if entity.active then
			entity:update(dt)
		end
	end

	for _, system in pairs(self.systems.update.objects) do
		if system.active then
			system:update(dt)
		end
	end
end

function CWorld:draw()
	for _, system in pairs(self.systems.draw.objects) do
		if system.active then
			system:draw()
		end
	end
end

return CWorld