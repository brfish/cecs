local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local CComponent = class("cecs_component")

function CComponent:init(name, construction)
	self.construction = construction
	self.name = name
end

function CComponent:getConstruction()
	return self.construction
end

function CComponent:setConstruction(construction)
	self.construction = construction
end

function CComponent:generate(...)
	return self.construction(...)
end

local CComponentPool = class("cecs_componentpool")

function CComponentPool:init()
	self.components = {}
end

function CComponentPool:add(component)
	if component.name then
		if not self.components[component.name] then
			self.components[component.name] = component
		else
			error("Fail to add component to pool: the component has existed")
		end
	else
		error("Fail to add component to pool: can not find the component name")
	end
end

function CComponentPool:set(component)
	if component.name then
		self.components[component.name] = component
	else
		error("Fail to set component: can not find the component name")
	end
end

function CComponentPool:create(name, construction)
	local component = CComponent.new(name, construction)
	self.components[name] = component
	return component
end

function CComponentPool:get(name1, ...)
	local components = {}
	if self.components[name1] then
		components[#components + 1] = self.components[name1]
	end
	for i = 1, #{...} do
		local name = select(i, ...)
		if self.components[name] then
			components[#components + 1] = self.components[name]
		end
	end
	return unpack(components)
end

return {
	Pool = CComponentPool,
	Component = CComponent
}