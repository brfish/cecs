local BASEDIR = (...):match("(.-)[^%.]+$")

local JuEvent = require(BASEDIR .. "event")

local EVENT_ENTITY_ADDED = class("EVENT_ENTITY_ADDED", JuEvent)
function EVENT_ENTITY_ADDED:init(system, entity)
	self.super.init(self)
	self.system = system
	self.entity = entity
end

local EVENT_ENTITY_REMOVED = class("EVENT_ENTITY_REMOVED", JuEvent)
function EVENT_ENTITY_REMOVED:init(system, entity)
	self.super.init(self)
	self.system = system
	self.entity = entity
end

local EVENT_COMPONENT_ADDED = class("EVENT_COMPONENT_ADDED", JuEvent)
function EVENT_COMPONENT_ADDED:init(entity, component, ...)
	self.super.init(self)
	self.entity = entity
	self.component = component
	self.parameters = {...}
end

local EVENT_COMPONENT_REMOVED = class("EVENT_COMPONENT_REMOVED", JuEvent)
function EVENT_COMPONENT_REMOVED:init(entity, component)
	self.super.init(self)
	self.entity = entity
	self.component = component
end

local EVENT_SYSTEM_ADDED = class("EVENT_SYSTEM_ADDED", JuEvent)
function EVENT_SYSTEM_ADDED:init(world, system, callback)
	self.super.init(self)
	self.world = world
	self.system = system
	self.callback = callback
end

local EVENT_SYSTEM_REMOVED = class("EVENT_SYSTEM_REMOVED", JuEvent)
function EVENT_SYSTEM_REMOVED:init(world, system, callback)
	self.super.init(self)
	self.world = world
	self.system = system
	self.callback = callback
end

local EVENT_SYSTEM_LOADED = class("EVENT_SYSTEM_LOADED", JuEvent)
function EVENT_SYSTEM_LOADED:init(system, callback)
	self.super.init(self)
	self.system = system
	self.callback = callback
end

local EVENT_SYSTEM_STOPPED = class("EVENT_SYSTEM_STOPPED", JuEvent)
function EVENT_SYSTEM_STOPPED:init(system, callback)
	self.super.init(self)
	self.system = system
	self.callback = callback
end

local EVENT_SYSTEM_STARTED = class("EVENT_SYSTEM_STARTED", JuEvent)
function EVENT_SYSTEM_STARTED:init(system, callback)
	self.super.init(self)
	self.system = system
	self.callback = callback
end

return {
	EVENT_ENTITY_ADDED = EVENT_ENTITY_ADDED,
	EVENT_ENTITY_REMOVED = EVENT_ENTITY_REMOVED,

	EVENT_COMPONENT_ADDED = EVENT_COMPONENT_ADDED,
	EVENT_COMPONENT_REMOVED = EVENT_COMPONENT_REMOVED,

	EVENT_SYSTEM_ADDED = EVENT_SYSTEM_ADDED,
	EVENT_SYSTEM_REMOVED = EVENT_SYSTEM_REMOVED,

	EVENT_SYSTEM_LOADED = EVENT_SYSTEM_LOADED,

	EVENT_SYSTEM_STOPPED = EVENT_SYSTEM_STOPPED,
	EVENT_SYSTEM_STARTED = EVENT_SYSTEM_STARTED
}