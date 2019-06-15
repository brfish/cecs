local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local OrderedTable = require(BASEDIR .. "ordered_table")
local EntityManager = require(BASEDIR .. "entity_manager")

local CWorld = class("cecs_world")

function CWorld:init()
	self.entityManager = OrderedTable.new()
	self.systems = OrderedTable.new()
end

function CWorld:update(dt)
	local it = self.systems:iterator()
	while it:next() do
		local system = it:get()
		system:update(dt)
	end
end

function CWorld:addEntity(entity)
	if not self.entityManager:exists(entity) then
		self.entityManager:insert(entity)
		for i = 1, #self.systems do
			if self.systems[i]:eligible(entity) then
				self.systems[i]:addEntity(entity)
			end
		end
	end
end

function CWorld:addSystem(system)
	if self.systems:exists(system) then
		system:setWorld(self)
		self.systems:insert(system)
	end
end

function CWorld:removeEntity(entity)
	if self.entityManager:exists(entity) then
		self.entityManager:remove(entity)
		for i = 1, #self.systems do
			if self.systems[i]:existsEntity(entity) and self.systems[i]:eligible(entity) then
				self.systems[i]:removeEntity(entity)
			end
		end
	end
end

function CWorld:removeSystem(system)
	if self.systems:exists(system) then
		system:setWorld()
		self.systems:remove(system)
	end
end

function CWorld:containsSystem(system)
	return self.systems:exists(system)
end

function CWorld:containsEntity(entity)
	return self.entityManager:contains(entity)
end

function CWorld:getEntities()
	return self.entityManager
end

return CWorld