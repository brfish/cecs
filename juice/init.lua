local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "juice.class")

local Entity = require(BASEDIR .. "juice.entity")

local Component = require(BASEDIR .. "juice.component").Component
local ComponentPool = require(BASEDIR .. "juice.component").Pool

local System = require(BASEDIR .. "juice.system")

local Event = require(BASEDIR .. "juice.event")
local EventManager = require(BASEDIR .. "juice.event_manager")

local World = require(BASEDIR .. "juice.world")

local Types = require(BASEDIR .. "juice.type_info")

local juice = {
	Entity = Entity,
	Component = Component,
	ComponentPool = ComponentPool,
	System = System,
	Event = Event,
	EventManager = EventManager,
	World = World,
	Types = Types
}

function juice.newEntity()
	return Entity.new()
end

function juice.newWorld()
	return World.new()
end

function juice.newComponent(name, func)
	return Component.new(name, func)
end

function juice.newComponentPool()
	return ComponentPool.new()
end

return juice