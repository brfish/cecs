local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local JuEvent = class("juice_event")

function JuEvent:init()
	self.__isEvent = true
	
	local name = self.__cname

	if not name or type(name) ~= "string" then
		error("Fail to create event object: the event type is a must for the object")
	end
	self.eventType = name
end

function JuEvent:getType()
	return self.eventType
end

return JuEvent