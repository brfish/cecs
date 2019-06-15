
local Event = class("cecs_event")

function Event:initialize(eventType)
	self.alive = true
	if eventType then
		self.eventType = eventType
	else
		error("Failed to initialize the event: The event type was not true")
	end
end

function Event:isAlive()
	return self.alive
end

function Event:kill()
	self.alive = false
end

function Event:getType()
	return self.eventType
end

function Event:__tostring()
	return string.format("Event Object[%s]", self.eventType)
end

return Event