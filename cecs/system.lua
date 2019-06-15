local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local OrderedTable = require(BASEDIR .. "ordered_table")

local CSystem = class("cecs_system")

function CSystem:init(component, ...)

	self.world = nil
	self.filter = OrderedTable.new()
	self.entityCache = OrderedTable.new()
	
	for i = 1, #{...} do
		local c = select(i, ...)
		if not self.filter:exists(c) then
			self.filter:insert(c)
		end
	end
end

function CSystem:getComponentFilter()
	return self.filter
end

function CSystem:setComponentFilter(filter)
	self.filter:clear()
	for i = 1, #filter do
		self.filter:insert(filter[i])
	end
end

function CSystem:addComponentFilter(component)
	if not self.filter.exists(component) then
		self.filter:insert(component)
	end
end

function CSystem:removeComponentFilter(component)
	if self.filter:exists(component) then
		self.filter:remove(component)
	end
end

function CSystem:setWorld(world)
	if world then
		self.world = world
	else
		self.world = nil
	end
end

function CSystem:getEntities()
	return self.entityCache
end

function CSystem:existsEntity(entity)
	return self.entityCache:exists(entity)
end

function CSystem:addEntity(entity)
	if not self.entityCache:exists(entity) then
		self.entityCache:insert(entity)
	end
end

function CSystem:removeEntity(entity)
	if self.entityCache:exists(entity) then
		self.entityCache:remove(entity)
	end
end

function CSystem:eligible(entity)
	local filterIterator = self.filter:iterator()
	while filterIterator do
		local component = filterIterator:get()
		if not entity:contains(component) then
			return false
		end
	end
	return true
end

function CSystem:update(dt)
end



function CSystem:onAdd(entity)
end

function CSystem:onRemove(entity)
end



function CSystem:trigger(event)

end

function CSystem:draw(entityManager, dt)
end

return CSystem