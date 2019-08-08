local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "class")
local Types = require(BASEDIR .. "type_info")

local JuEventManager = class("juice_eventmanager")

function JuEventManager:init()
	self.__isEventManager = true

	self.world = nil

	self.listeners = {}

	self.activeQueue = 0
	self.queue = {[0] = {}, [1] = {}}

end

function JuEventManager:setWorld(world)
	if not Types.isWorld(world) then
		Types.error(world, "world")
	end
	self.world = world or nil
end

function JuEventManager:addListener(eventType, listener)
	if not Types.isSystem(listener) then
		Types.error(system, "system")
	end

	if self.listeners[eventType] == nil then
		self.listeners[eventType] = {}
	end

	for i = 1, #self.listeners[eventType] do
		if self.listeners[eventType][i] == listener then
			error("Fail to add listener to event manager: the listener has existed")
			return
		end
	end

	if listener.receive == nil or type(listener.receive) ~= "function" then
		error("Fail to add listener to event manager: the listener has no receive function")
		return
	end

	self.listeners[eventType][#self.listeners[eventType] + 1] = listener
end

function JuEventManager:removeListener(eventType, listener)
	if not Types.isSystem(listener) then
		Types.error(listener, "system")
	end

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

function JuEventManager:queueEvent(event)
	if not Types.isEvent(event) then
		Types.error(event, "event")
	end

	local eventType = event:getType()

	local active = self.queue[self.activeQueue]
	active[#active + 1] = event
end

function JuEventManager:abortFirstEvent(event)
	if not Types.isEvent(event) then
		Types.error(event, "event")
	end

	local eventType = event:getType()

	local active = self.queue[self.activeQueue]

	for i = 1, #active do
		if active[i] == event then
			table.remove(active, i)
			return
		end
	end
end

function JuEventManager:abortLastEvent(event)
	if not Types.isEvent(event) then
		Types.error(event, "event")
	end

	local eventType = event:getType()

	local active = self.queue[self.activeQueue]

	for i = #active, 1, -1 do
		if active[i] == event then
			table.remove(active, i)
			return
		end
	end

end

function JuEventManager:abortAllEvent(event)
	if not Types.isEvent(event) then
		Types.error(event, "event")
	end

	local eventType = event:getType()

	local active = self.queue[self.activeQueue]

	for i = #active, 1, -1 do
		if active[i] == event then
			table.remove(active, i)
		end
	end

end

function JuEventManager:triggerEvent(event)
	if not Types.isEvent(event) then
		Types.error(event, "event")
	end

	local eventType = event:getType()
	if not self.listeners[eventType] then
		error("Fail to trigger the event: the listener is not existed")
		return
	end
	for i = 1, #self.listeners[eventType] do
		local listener = self.listeners[eventType][i]
		listener:receive(event)
	end
	
end

function JuEventManager:triggerAll()
	local current = self.queue[self.activeQueue]

	self.activeQueue = (self.activeQueue + 1) % 2
	self.queue[self.activeQueue] = {}

	for i = 1, #current do
		local eventType = current[i]:getType()
		if not self.listeners[eventType] then
			error("Fail to trigger the event: the listener is not existed")
			return
		end
		for j = 1, #self.listeners[eventType] do
			local listener = self.listeners[eventType][j]
			listener:receive(current[i])
		end
	end
end

function JuEventManager:update(timelimit)
	local startTime = love.timer.getTime()
	timelimit = timelimit or 1 / 120

	local current = self.queue[self.activeQueue]
	self.activeQueue = (self.activeQueue + 1) % 2

	self.queue[self.activeQueue] = {}

	local point = 1
	while point <= #current do
		local eventType = current[point]:getType()
			if not self.listeners[eventType] then
				error("Fail to trigger the event: the listener is not existed")
			end
			for i = 1, #self.listeners[eventType] do
				local listener = self.listeners[eventType][i]
				listener:receive(current[point])
			end

		if love.timer.getTime() - startTime >= timelimit then
			break
		end

		point = point + 1
	end

	if point < #current then
		for i = point + 1, #current do
			self.queue[self.activeQueue][#self.queue[self.activeQueue] + 1] = current[i]
		end
	end

	current = nil
end

function JuEventManager:clear()
	self.queue[0] = {}
	self.queue[1] = {}

	self.activeQueue = 0

	for eventType, _ in pairs(self.listeners) do
		self.listeners[eventType] = {}
	end
end

return JuEventManager