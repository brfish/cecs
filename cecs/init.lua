local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "cecs.class")

local Entity = require(BASEDIR.."cecs.entity")
local Component = require(BASEDIR .. "cecs.component")
local System = require(BASEDIR.."cecs.system")
local World = require(BASEDIR.."cecs.world")

local cecs = {
	Entity = Entity,
	Component = Component,
	System = System,
	World = World
}

return cecs