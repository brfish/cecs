local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "class")
local Types = require(BASEDIR .. "type_info")

local JuComponent = class("juice_component")

function JuComponent:init(name, construction)
	self.__isComponent = true

	self.construction = construction
	self.name = name
end

function JuComponent:getConstruction()
	return self.construction
end

function JuComponent:setConstruction(construction)
	self.construction = construction
end

function JuComponent:generate(...)
	return self.construction(...)
end

local JuComponentPool = class("juice_componentpool")

function JuComponentPool:init()
	self.components = {}
end

function JuComponentPool:add(component)
	if not Types.isComponent(component) then
		Types.error(component, "component")
	end

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

function JuComponentPool:set(component)
	if not Types.isComponent(component) then
		Types.error(component, "component")
	end
	
	if component.name then
		self.components[component.name] = component
	else
		error("Fail to set component: can not find the component name")
	end
end

function JuComponentPool:create(name, construction)
	local component = JuComponent.new(name, construction)
	self.components[name] = component
	return component
end

function JuComponentPool:get(name1, ...)
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
	Component = JuComponent,
	Pool = JuComponentPool
}