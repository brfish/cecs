local BASEDIR = (...):match("(.-)[^%.]+$")

__NULL__ = {"__NULL__"}

local class = require(BASEDIR .. "cecs.class")

local Entity = require(BASEDIR.."cecs.entity")
local EntityManager = require(BASEDIR.."cecs.entity_manager")
local System = require(BASEDIR.."cecs.system")
local Event = require(BASEDIR.."cecs.event")
local EventManager = require(BASEDIR.."cecs.event_manager")
local EventSystem = require(BASEDIR.."cecs.event_system")
local World = require(BASEDIR.."cecs.world")
--require(BASEDIR.."cecs.builtin_events")

local cecs = {}

local ComponentAddedEvent = class("ComponentAddedEvent", Event)
function ComponentAddedEvent:initialize(entity, component)
	Event.initialize(self)
	self.entity = entity
	self.component = component
end

local ComponentRemovedEvent = class("ComponentRemovedEvent", Event)
function ComponentRemovedEvent:initialize(entity, component)
	Event.initialize(self)
	self.entity = entity
	self.component = component
end

local EntityCreatedEvent = class("EntityCreatedEvent", Event)
function EntityCreatedEvent:initialize(entity)
	Event.initialize(self)
	self.entity = entity
end

local EntityDestroyedEvent = class("EntityCreatedEvent", Event)
function EntityDestroyedEvent:initialize(entity)
	Event.initialize(self)
	self.entity = entity
end

cecs.ComponentAddedEvent = ComponentAddedEvent
cecs.ComponentRemovedEvent = ComponentRemovedEvent
cecs.EntityCreatedEvent = EntityCreatedEvent
cecs.EntityDestroyedEvent = EntityDestroyedEvent

cecs.defaultWorld = World()

cecs.Entity = Entity
cecs.EntityManager = EntityManager
cecs.System = System
cecs.Event = Event
cecs.EventManager = EventManager
cecs.EventSystem = EventSystem
cecs.World = World

function typeOf(object)
	if object.class.name then
		return object.class.name
	end
	return type(object)
end

function cecs.newSystem(paramaters)
	local system = System(paramaters)
	if paramaters then
		for k, v in pairs(paramaters) do
			system[k] = v
		end
	end
	cecs.defaultWorld:addSystem(system)
	return system
end

function cecs.newEntity(paramaters)
	local entity = Entity()
	if paramaters then
		for k, v in pairs(paramaters) do
			entity[k] = v
		end
	end
	cecs.defaultWorld:addEntity(entity)
	return entity
end

function cecs.newWorld()
	local world = World()
	return world
end

function cecs.update(dt)
	cecs.defaultWorld:update(dt)
end

function cecs.draw()
	cecs.defaultWorld:draw()
end

function cecs.addEntity(entity)
	cecs.defaultWorld:addEntity(entity)
end

function cecs.addSystem(system)
	cecs.defaultWorld:addSystem(system)
end

function cecs.register(object)
	cecs.defaultWorld:register(object)
end

return cecs