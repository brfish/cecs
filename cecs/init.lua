local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "cecs.class")

local Entity = require(BASEDIR .. "cecs.entity")

local Component = require(BASEDIR .. "cecs.component").Component
local ComponentPool = require(BASEDIR .. "cecs.component").Pool

local System = require(BASEDIR .. "cecs.system")

local Event = require(BASEDIR .. "cecs.event")
local EventManager = require(BASEDIR .. "cecs.event_manager")

local World = require(BASEDIR .. "cecs.world")

local Types = require(BASEDIR .. "cecs.type_info")

local cecs = {
	Entity = Entity,
	Component = Component,
	ComponentPool = ComponentPool,
	System = System,
	Event = Event,
	EventManager = EventManager,
	World = World,
	Types = Types
}

return cecs