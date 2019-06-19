
local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local CEventManager = class("cecs_eventmanager")

function CEventManager:init()

	self.listeners = {}

	self.activeQueue = 0
	self.queue = {[0] = {}, [1] = {}}
end

function CEventManager:addListener(eventType, listener)

	if self.listeners[eventType] == nil then
		self.listeners[eventType] = {}
	end

	for i = 1, #self.listeners[eventType] do
		if self.listeners[eventType][i] == listener then
			error("Fail to add listener to event manager: the listener has existed")
			return
		end
	end
	print(tostring(listener.receive == nil), type(listener.receive))
	if listener.receive == nil or type(listener.receive) ~= "function" then
		error("Fail to add listener to event manager: the listener has no receive function")
		return
	end

	self.listeners[eventType][#self.listeners[eventType] + 1] = listener
end

function CEventManager:removeListener(eventType, listener)

	if not self.listeners[eventType] then
		error("Fail to remove the listener: the listener is not existed")
		return
	end

	for i = #self.listeners[eventType], 1, -1 do
		if self.listeners[eventType][i] == listener then
			table.remove(self.listeners[eventType], i)
			if #self.listeners[eventType] == 0 then
				self.listeners[eventType] = nil
			end
			return
		end
	end

	error("Fail to remove the listener: the listener is not existed")

end

function CEventManager:queueEvent(event)

	local eventType = event:getType()

	--if self.listeners[eventType] then
		local active = self.queue[self.activeQueue]
		active[#active + 1] = event
	--end
end

function CEventManager:abortFirstEvent(event)

	local eventType = eventType:getType()

	local active = self.queue[self.activeQueue]

	for i = 1, #active do
		if active[i] == event then
			table.remove(active, i)
			return
		end
	end

end

function CEventManager:abortLastEvent(event)

	local eventType = eventType:getType()

	local active = self.queue[self.activeQueue]

	for i = #active, 1, -1 do
		if active[i] == event then
			table.remove(active, i)
			return
		end
	end

end

function CEventManager:abortAllEvent(event)

	local eventType = eventType:getType()

	local active = self.queue[self.activeQueue]

	for i = #active, 1, -1 do
		if active[i] == event then
			table.remove(active, i)
		end
	end

end



function CEventManager:update(maxtime)
	local startTime = love.timer.getTime()
	maxtime = maxtime or 1 / 120

	local current = self.queue[self.activeQueue]
	self.activeQueue = (self.activeQueue + 1) % 2

	self.queue[self.activeQueue] = {}

	local point = 1
	while point <= #current do
		local eventType = current[point]:getType()
			for i = 1, #self.listeners[eventType] do
				local listener = self.listeners[eventType][i]
				listener:receive(current[point])
			end

		if love.timer.getTime() - startTime >= maxtime then
			break
		end

		point = point + 1
	end

	if point < #current then
		for i = point + 1, #current do
			self.queue[self.activeQueue][#self.queue[self.activeQueue] + 1] = current[i]
		end
	end
end

return CEventManager