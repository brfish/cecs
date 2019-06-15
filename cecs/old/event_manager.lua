local EventManager = class("EventManager")

function EventManager:initialize()
	self.eventQueue = {[1] = {}, [2] = {}}
	self.activeQueue = 1
	self.eventMap = {}

	self.observerList = {}
end

local function swapActiveQueue(queue)
	if queue and queue == 1 or queue == 2 then
		self.activeQueue = queue
		return
	end
	if self.activeQueue == 1 then
		self.activeQueue = 2
	elseif self.activeQueue == 2 then
		self.activeQueue = 1
	end
end

--[[function EventManager:register(eventType)
	if self.events[eventType] == nil then
		self.events[eventType] = {}
	else
		return false
	end
	return true
end

function EventManager:cancel(eventType)
	if self.events[eventType] then
		self.events[eventType] = nil
		return true
	end
	return false
end]]

function EventManager:send(event, ...)
	local events = {...}
	events[#events + 1] = event
	--self.eventMap[event:getType()][#self.eventMap[event:getType()]+1] = event
	for _, _event in ipairs(events) do
		self.eventQueue[self.activeQueue][#self.eventQueue[self.activeQueue] + 1] = _event
		--self.eventMap[t][#self.eventMap[t]+1] = v
	end
	--print(#self.eventQueue[self.activeQueue])
end

function EventManager:fetch(eventType)
	local events = {}
	if eventType then
		for _, event in ipairs(self.eventQueue[self.activeQueue]) do
			if event:getType() == eventType then
				events[#events+1] = event
			end
		end
		return events
	end
	return self.eventQueue[self.activeQueue]
	--if eventType then
	--	return self.eventMap[eventType]
	--end
	--return self.eventQueue
end

function EventManager:pop()
	local event = self.eventQueue[self.activeQueue][#self.eventQueue]
	table.remove(self.eventQueue[self.activeQueue], #self.eventQueue)
	return event
end

function EventManager:abort(event, isAll)
	if not isAll then
		for i = #self.eventQueue[self.activeQueue], 1, -1 do
			if self.eventQueue[self.activeQueue][i] == event then
				table.remove(self.eventQueue[self.activeQueue], i)
				return true
			end
		end
		return false
	end
	local success = false
	for i = #self.eventQueue[self.activeQueue], 1, -1 do
		if self.eventQueue[self.activeQueue][i] == event then
			table.remove(self.eventQueue[self.activeQueue], i)
			success = true
		end
	end
	return success
end

--[[function EventManager:send(eventType, event, ...)
	if self.events[eventType] == nil then
		error("Failed to send evnets: The event type was not existed")
		--self:register(eventType)
	end
	--self.events[eventType][event] = event
	self.events[eventType][#self.events[eventType]+1] = event
	self.eventCount = self.eventCount+1
	for i = _, v in ipairs({...}) do
		self.events[eventType][#self.events[eventType]+1] = v
		self.eventCount = self.eventCount+1
	end
end]]

function EventManager:clear(eventType)
	if eventType then
		--for _, event in pairs(self.events[eventType]) do
		--	self:destroy(eventType, event)
		--end
		for i = #self.events[eventType], 1, -1 do
			table.remove(self.events[eventType], i)
		end
		return
	end
	for _, et in pairs(self.events) do
		for i = #et, 1, -1 do
			table.remove(et, i)
		end
	end
end

function EventManager:addObserver(observer, eventType, ...)
	local eventTypes = {...}
	eventTypes[#eventTypes+1] = eventType
	for _, _eventType in ipairs(eventTypes) do
		if not self.observerList[_eventType] then
			self.observerList[_eventType] = {}
		else
			for i = 1, #self.observerList[_eventType] do
				local o = self.observerList[_eventType][i]
				if o == observer then
					error("Failed to add observer: The observer has existed")
					return false
				end
			end
		end
	end
	--self.observerList[#self.observerList+1] = observer
	for _, _eventType in ipairs(eventTypes) do
		self.observerList[_eventType][#self.observerList[_eventType]+1] = observer
	end
	return true
	--[[if self.events[eventType] then
		self.observerList[#self.observerList+1] = {observer = observer, eventType = eventType}
	else
		error("Failed to add observer: The event type which observer needed was not existed")
	end]]
end

function EventManager:removeObserver(observer, eventType)
	if eventType then
		for i = #self.observerList[eventType], 1, -1 do
			local o = self.observerList[eventType][i]
			if o == observer then
				table.remove(self.observerList[eventType], i)
				return true
			end
		end
		return false
	end
	local success = false
	for _, list in pairs(self.observerList) do
		for i = #list, 1, -1 do
			local o = list[i]
			if o == observer then
				table.remove(list, i)
				success = true
			end
		end
	end
	return success
end

function EventManager:distribute(maxTime)

	local currentQueue = self.activeQueue
	self.activeQueue = self.activeQueue % 2 + 1
	self.eventQueue[self.activeQueue] = {}
	for _, _event in ipairs(self.eventQueue[currentQueue]) do
		local eventType = _event:getType()
		for i = 1, #self.observerList[eventType] do
			local o = self.observerList[eventType][i]
			o:trigger(_event)
		end
	end
end

--[[function EventManager:registerReceiver(eventType, receiver)
	if self.eventReceiverList[eventType] then
		for _, v in ipairs(self.eventReceiverList[eventType]) do
			if v == receiver then
				return false
			end
		end
		self.eventReceiverList[eventType][self.eventReceiverList[eventType]+1] = receiver
	else
		self.eventReceiverList[eventType] = {}
		self.eventReceiverList[eventType][self.eventReceiverList[eventType]+1] = receiver
	end
	return true
end



function EventManager:create(eventType)
	if not self.events[eventType] then
		self:register(eventType)
	end
	local event = Event()
	self.events[eventType][event] = event
	self.eventCount = self.eventCount+1
	return event
end

function EventManager:destroy(eventType, event)
	if self.events[eventType] then
		if self.events[eventType][event] then
			self.events[eventType][event] = nil
			self.eventCount = self.eventCount-1
		else
			error("Failed to destroy the event: Could not find the event")
		end
	else
		error("Failed to destroy the event: Could not find the eventType")
	end
end]]



return EventManager