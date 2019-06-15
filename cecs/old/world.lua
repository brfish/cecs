local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "class")
local EntityManager = require(BASEDIR .. "entity_manager")
local EventManager = require(BASEDIR .. "event_manager")

local CWorld = class("cecs_world")

function CWorld:init()
	self.systems = {}
	self.systemFlag = {}

	self.eventSystems = {}

	self.entityManager = EntityManager.new()
	self.eventManager = EventManager()

	self.systemCount = 0
	self.eventSystemCount = 0

	self.eventOption = {
		entityCreated = false,
		entityDestroyed = false,
		componentAdded = false,
		componentRemoved = false
	}
end

function CWorld:createEntity(...)
	local entity = self.entityManager:create()
	for _, component in ipairs({...}) do
		self:addComponentToEntity(entity, component)
		
		--self.entityManager:assign(entity, component)
	end
	if self.eventOption.entityCreated then
		self.eventManager:send(cecs.EntityCreatedEvent(entity))
		--_entityCreatedSystem:send(self.eventManager, "EntityCreatedEvent", EntityCreatedEvent(entity))
	end
	return entity
end

function CWorld:destroyEntity(entity)
	self.eventManager:destroy(entity)
	if self.eventOption.entityDestroyed then
		self.eventManager:send(cecs.EntityDestroyedEvent(entity))
		--_entityDestroyedSystem:send(self.eventManager, "EntityDestroyedEvent", EntityDestroyedEvent(entity))
	end
end

function CWorld:addComponentToEntity(entity, component)
	self.entityManager:addComponentToEntity(entity, component)
	if self.eventOption.componentAdded then
		self.eventManager:send(cecs.ComponentAddedEvent(entity, component))
		--_componentAddedSystem:send(self.eventManager, "ComponentAddedEvent", ComponentAddedEvent(entity, component[1]))
	end
	--[[if not self.entityManager:exists(entity) then
		error("Failed to assign the entity: Could not find the entity")
	end
	for _, component in ipairs({...}) do
		self.entityManager:assign(entity, component)
		if self.eventOption.componentAdded then
			_componentAddedSystem:send(self.eventManager, "ComponentAddedEvent", ComponentAddedEvent(entity))
		end
	end]]
end

function CWorld:removeComponentFromEntity(entity, component)
	self.entityManager:removeComponentFromEntity(entity, component)
	if self.eventOption.componentRemoved then
		self.eventManager:send(cecs.ComponentRemovedEvent(entity, component))
		--_componentRemovedSystem:send(self.eventManager, "ComponentRemovedEvent", ComponentRemovedEvent(entity, component))
	end
	--[[if not self.entityManager:exists(entity) then
		error("Failed to remove the component from the entity: Could not find the entity"))
	end
	if entity:existsComponent(component) then
		self.entityManager:removeComponent(entity, )]]
end

function CWorld:addEntity(entity)
	self.entityManager:ad

function CWorld:addSystem(system)
	if self.systemFlag[system] == nil then
		system:setEntityManager(self.entityManager)
		self.systems[#self.systems + 1] = system
		self.systemFlag[system] = true
		self.systemCount = self.systemCount + 1
	end
end

function CWorld:addEventSystem(system)
	self.eventSystems[system] = system
	self.eventSystemCount = self.eventSystemCount+1
end

function CWorld:removeSystem(system)
	self.systems[system] = nil
	self.systemCount = self.systemCount-1
end

function CWorld:removeEventSystem(system)
	self.eventSystems[system] = nil
	self.eventSystemCount = self.eventSystemCount-1
end

function CWorld:getSystemCount()
	if self.systemCount >= 0 then
		return self.systemCount
	end
	error("Unknown error")
end

function CWorld:getEventSystemCount()
	if self.eventSystemCount >= 0 then
		return self.eventSystemCount
	end
	error("Unknown error")
end

function CWorld:updateSystem(system, dt)
	local _system = self.systems[system]
	if _system then
		if _system:isAlive() then
			_system:update(self.entityManager, dt)
		else
			self:removeSystem(system)
		end
	else
		error("Failed to update the system: Can't find this system")
	end
end

function CWorld:updateAll(dt)
	for _, system in pairs(self.systems) do
		if system:isAlive() then
			system:update(self.entityManager, dt)
		else
			self.systems[system] = nil
		end
	end
end

function CWorld:updateEventSystem(dt)
	for _, system in pairs(self.eventSystems) do
		if system:isAlive() then
			system:update(self.entityManager, self.eventManager, dt)
		else
			self.eventSystems[system] = nil
		end
	end
end

function CWorld:updateEvents(dt)
	self.eventManager:distribute(dt)
end

function CWorld:isSystemExisted(system)
	return self.systems[system] ~= nil
end

function CWorld:update(dt)
end

function CWorld:draw()
end

return CWorld