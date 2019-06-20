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

	for _, callback in pairs(self.systems) do
		for __, system in pairs(callback.objects) do
			if system:eligible(entity) then
				system:addEntity(entity)
				if self.eventManagerOptions.event_entity_added_enable then
					self.eventManager:queueEvent(
						BuiltinEvents.EVENT_ENTITY_ADDED(system, entity))
				end
			end
		end
	end

	return entity
end

function CWorld:removeEntity(entity)

	self.entityManager:removeEntity(entity)

	for _, callback in pairs(self.systems) do
		for __, system in pairs(callback) do
			if system.active then
				system:removeEntity(entity)
				if self.eventManagerOptions.event_entity_removed_enable then
					self.eventManager:queueEvent(
						BuiltinEvents.EVENT_ENTITY_REMOVED(system, entity))
				end
			end
		end
	end
end

function CWorld:addSystem(system, callback)

	local name = system.__cname
	if self.registeredSystems[callback][name] then
		error("Fail to add system to the world: the system " .. name .. " has existed")
		return
	end

	if not system[callback] then
		error("Fail to add system to the world: the system is without the designative callback function")
		return
	end

	system:setWorld(self)

	if not self.systems[callback] then
		self.systems[callback] = {point = 0, objects = {}, size = 0}
	end

	self.systems[callback].point = self.systems[callback].point + 1
	local point = self.systems[callback].point
	self.systems[callback].objects[point] = system
	self.registeredSystems[name][callback] = point

	if self.eventManagerOptions.event_system_added_enable then
		self.eventManager:queueEvent(
			BuiltinEvents.EVENT_SYSTEM_ADDED(self, system))
	end

	local entities = self.entityManager:getAllEntities()
	for _, entity in pairs(entities) do
		if system:eligible(entity) then
			system:addEntity(entity)
		end
	end

	return system
end

function CWorld:removeSystem(system, callback)

	local name = system.__cname		

	if not self.registeredSystems[name][callback] then
		error("Fail to remove the system: the system is not existed")
		return
	end

	index = self.registeredSystems[name][callback]
	self.systems[callback].objects[index] = nil
	self.registeredSystems[name][callback] = nil
	self.systems[callback].size = self.systems[callback].size - 1

	if self.eventManagerOptions.event_system_removed_enable then
		self.eventManager:queueEvent(
			BuiltinEvents.EVENT_SYSTEM_REMOVED(self, system, callback))
	end
end

function CWorld:stopSystem(system, callback)
	local name = system.__cname

	if not self.registeredSystems[name][callback] then
		error("Faile to stop the system: the system is not existed")
		return
	end

	system:deactivate()
end

function CWorld:startSystem(system, callback)
	local name = system.__cname

	if not self.registeredSystems[name][callback] then
		error("Faile to continue the system: the system is not existed")
		return
	end

	system:activate()
end

function CWorld:containsSystem(system, callback)
	if callback then
		return self.registeredSystems[system][callback] ~= nil
	end
	return self.registeredSystems[system] ~= nil
end

function CWorld:containsEntity(entity)
	return self.entityManager:contains(entity)
end

function CWorld:getAllEntities()
	return self.entityManager:getAllEntities()
end

function CWorld:run(callback, ...)
	if not self.systems[callback] then
		error("Fail to run the callbacks: the callback is not existed")
		return
	end

	for _, system in pairs(self.systems[callback].objects) do
		if system.active then
			system[callback](system, ...)
		end
	end
end

return CWorld