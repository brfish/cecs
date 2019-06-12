local BASEDIR = (...):match("(.-)[^%.]+$")
local Event = require(BASEDIR.."event")
local EventSystem = require(BASEDIR.."event_system")

ComponentAddedEvent = class("ComponentAddedEvent", Event)
function ComponentAddedEvent:initialize(entity, component)
	Event.initialize(self)
	self.entity = entity
	self.component = component
end

ComponentRemovedEvent = class("ComponentRemovedEvent", Event)
function ComponentRemovedEvent:initialize(entity, component)
	Event.initialize(self)
	self.entity = entity
	self.component = component
end

EntityCreatedEvent = class("EntityCreatedEvent", Event)
function EntityCreatedEvent:initialize(entity)
	Event.initialize(self)
	self.entity = entity
end

EntityDestroyedEvent = class("EntityCreatedEvent", Event)
function EntityDestroyedEvent:initialize(entity)
	Event.initialize(self)
	self.entity = entity
end

EntityCreatedSystem = class("EntityCreatedSystem", EventSystem.Sender)
function EntityCreatedSystem:initialize()
	EventSystem.Sender.initialize(self)
end

EntityDestroyedSystem = class("EntityDestroyedSystem", EventSystem.Sender)
function EntityDestroyedSystem:initialize()
	EventSystem.Sender.initialize(self)
end

ComponentAddedSystem = class("ComponentAddedSystem", EventSystem.Sender)
function ComponentAddedSystem:initialize()
	EventSystem.Sender.initialize(self)
end

ComponentRemovedSystem = class("ComponentRemovedSystem", EventSystem.Sender)
function ComponentRemovedSystem:initialize()
	EventSystem.Sender.initialize(self)
end

_entityCreatedSystem = EntityCreatedSystem()
_entityDestroyedSystem = EntityDestroyedSystem()
_componentAddedSystem = ComponentAddedSystem()
_componentRemovedSystem = ComponentRemovedSystem()


EntityCreatedReceiver = class("EntityCreatedReceiver", EventSystem.Receiver)
function EntityCreatedReceiver:initialize()
	EventSystem.Receiver.initialize(self)
end

entityCreatedReceiver = EntityCreatedReceiver()
