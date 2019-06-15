local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local CComponent = class("cecs_component")

function CComponent:init(construction)
	self.construction = construction
end

function CComponent:getConstruction()
	return self.construction
end

function CComponent:setConstruction(construction)
	self.construction = construction
end

function CComponent:create(...)
	return self.construction(...)
end

return CComponent