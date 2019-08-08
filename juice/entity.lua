local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "class")
local BuiltinEvents = require(BASEDIR .. "builtin_events")
local Types = require(BASEDIR .. "type_info")

local JuEntity = class("juice_entity")

function JuEntity:init()
	self.__isEntity = true

	self.entityManager = nil

	self.components = {}

	self.id = -1

	self.active = true
end

function JuEntity:isActive()
	return self.active
end

function JuEntity:setManager(manager)
	if manager and not Types.isEntityManager(manager) then
		Types.error(manager, "entitymanager")
	end

	if manager then
		self.entityManager = manager
		self.id = manager:assignNewId()
	else
		self.entityManager = nil
		self.id = -1
	end
end

function JuEntity:addComponent(component, ...)
	if not Types.isComponent(component) then
		Types.error(component, "component")
	end

	local name = component.name

	if self.components[name] == nil then
		self.components[name] = component:generate(...)
	else
		error("Fail to add the component to the entity: the component has existed")
		return
	end

	if not self.entityManager or not self.entityManager.world then return self end

	local world = self.entityManager.world
	if not world.eventManagerOptions.event_component_added_enable then return self end
	
	world.eventManager:queueEvent(BuiltinEvents.EVENT_COMPONENT_ADDED.new(component, self, ...))

	return self
end

function JuEntity:removeComponent(component)
	if self.components[component] then
		self.components[component] = nil
	else
		error("Fail to remove the component from the entity: the component is not existed")
	end

	if not self.entityManager or not self.entityManager.world then return self end

	local world = self.entityManager.world
	if not world.eventManagerOptions.event_component_removed_enable then return self end
	
	world.eventManager:queueEvent(BuiltinEvents.EVENT_COMPONENT_REMOVED.new(component, self))

	return self
end

function JuEntity:get(component)
	if self.components[component] == nil then
		return nil
	end
	local ctype = type(self.components[component])
	if ctype == "number" or ctype == "boolean" or ctype == "string" then
		local value = self.components[component]
		self.components[component] = {value}
	end
	return self.components[component]
end

function JuEntity:getAll()
	return self.components
end

function JuEntity:getComponentsList()
	local list = {}
	for ctype, _ in pairs(self.components) do
		list[#list + 1] = ctype
	end
	return list
end

function JuEntity:contains(component)
	return self.components[component] ~= nil
end

function JuEntity:activate()
	self.active = true
end

function JuEntity:deactivate()
	self.active = false
end

function JuEntity:isActive()
	return self.active
end

return JuEntity