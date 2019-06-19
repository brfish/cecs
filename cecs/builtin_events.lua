local BASEDIR = (...):match("(.-)[^%.]+$")

local CEvent = require(BASEDIR .. "event")

local EVENT_ENTITY_ADDED = class("EVENT_ENTITY_ADDED", CEvent)
function EVENT_ENTITY_ADDED:init(system, entity)
	self.super.init(self)
	self.system = system
	self.entity = entity
end

local EVENT_ENTITY_REMOVED = class("EVENT_ENTITY_REMOVED", CEvent)
function EVENT_ENTITY_REMOVED:init(system, entity)
	self.super.init(self)
	self.system = system
	self.entity = entity
end

local EVENT_COMPONENT_ADDED = class("EVENT_COMPONENT_ADDED", CEvent)
function EVENT_COMPONENT_ADDED:init(entity, component)
	self.super.init(self)
	self.entity = entity
	self.component = component
end

local EVENT_COMPONENT_REMOVED = class("EVENT_COMPONENT_REMOVED", CEvent)
function EVENT_COMPONENT_REMOVED:init(entity, component)
	self.super.init(self)
	self.entity = entity
	self.component = component
end

local EVENT_SYSTEM_ADDED = class("EVENT_SYSTEM_ADDED", CEvent)
function EVENT_SYSTEM_ADDED:init(world, system)
	self.super.init(self)
	self.world = world
	self.system = system
end

local EVENT_SYSTEM_REMOVED = class("EVENT_SYSTEM_REMOVED", CEvent)
function EVENT_SYSTEM_REMOVED:init(world, system)
	self.super.init(self)
	self.world = world
	self.system = system
end

return {
	EVENT_ENTITY_ADDED = EVENT_ENTITY_ADDED,
	EVENT_ENTITY_REMOVED = EVENT_ENTITY_REMOVED,

	EVENT_COMPONENT_ADDED = EVENT_COMPONENT_ADDED,
	EVENT_COMPONENT_REMOVED = EVENT_COMPONENT_REMOVED,

	EVENT_SYSTEM_ADDED = EVENT_SYSTEM_ADDED,
	EVENT_SYSTEM_REMOVED = EVENT_SYSTEM_REMOVED


}