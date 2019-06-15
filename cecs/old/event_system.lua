
--[[local EventSystem = {}

EventSystem.Sender = class("cherry_cecs_EventSystem_Sender")
EventSystem.Receiver = class("cherry_cecs_EventSystem_Receiver")

function EventSystem.Sender:initialize()
	self.alive = true
end

function EventSystem.Sender:update(entityManager, eventManager, dt)
end

function EventSystem.Sender:send(eventManager, eventType, event)
	eventManager:send(eventType, event)
end

function EventSystem.Sender:draw(entityManager, eventManager)
end

function EventSystem.Sender:isAlive()
	return self.alive
end

function EventSystem.Sender:kill()
	self.alive = false
end




function EventSystem.Receiver:initialize()
	self.alive = true
end

function EventSystem.Receiver:update(entityManager, eventManager, dt)
	for eventName, eventList in pairs(eventManager:get()) do
		for _, event in pairs(eventList) do
			self:receive(eventName, event)
			eventManager:destroy(eventName, event)
		end
	end
end

function EventSystem.Receiver:draw(entityManager, eventManager)
end

function EventSystem.Receiver:trigger(eventManager)
	for eventName, eventList in pairs(eventManager:get()) do
		for _, event in pairs(eventList) do
			self:receive(eventName, event)
			eventManager:destroy(eventName, event)
		end
	end
end

function EventSystem.Receiver:receive(eventType, event)
end

function EventSystem.Receiver:isAlive()
	return self.alive
end

function EventSystem.Receiver:kill()
	self.alive = false
end

return EventSystem]]

local EventSystem = class("cherry_cecs_EventSystem")

function EventSystem:initialize()
	self.alive = true
	self.active = true
end

function EventSystem:setActive(a)
	assert(type(a) == "boolean")
	self.active = a
end

function EventSystem:kill()
	self.alive = false
	return true
end

function EventSystem:isAlive()
	return self.alive
end

function EventSystem:update(entityManager, eventManager, dt)
end

return EventSystem