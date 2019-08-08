local BASEDIR = (...):match("(.-)[^%.]+$")

local class = require(BASEDIR .. "class")
local Types = require(BASEDIR .. "type_info")

local JuSystem = class("juice_system")

function JuSystem:init(requirements, rejects)
	self.__isSystem = true
	
	self.world = nil
	self.eventManager = nil

	self.entities = {}

	self.requirements = requirements or {}
	self.rejects = rejects or {}

	self.active = true
end

function JuSystem:setWorld(world)
	if not Types.isWorld(world) then
		Types.error(world, "world")
	end
	if world then
		self.world = world
		return
	end
	self.world = nil
end

function JuSystem:setEventManager(manager)
	if not Types.isEventManager(manager) then
		Types.error(manager, "eventmanager")
	end
	self.eventManager = manager or nil
end

function JuSystem:refresh()
	local toRemove = {}
	for id, entity in pairs(self.entities) do
		if not self:eligible(entity) then
			toRemove[#toRemove + 1] = id
		end
	end
	for i = 1, #toRemove do
		self.entities[toRemove[i]] = nil
	end
end

function JuSystem:setRequirements(requirements)
	self.requirements = requirements
	self:refresh()
end

function JuSystem:addRequirement(requirement)
	if type(self.requirements) == "function" then
		error("Fail to add requirement filter: the requirement has been set a function")
	end
	for i = 1, #self.requirements do
		if self.requirements[i] == filter then
			error("Fail to add requirement filter to system: the filter has existed")
			return
		end
	end
	self.requirements[#self.requirements + 1] = requirement
	self:refresh()
end

function JuSystem:removeRequirement(requirement)
	if type(self.requirements) == "function" then
		error("Fail to remove requirement filter: the requirement has been set a function")
	end
	for i = #self.requirements, 1, -1 do
		if self.requirements[i] == requirement then
			table.remove(self.requirements, i)
			self:refresh()
			return true
		end
	end
	return false
end

function JuSystem:setRejects(rejects)
	self.rejects = rejects
	self:refresh()
end

function JuSystem:addReject(reject)
	if type(self.requirements) == "function" then
		error("Fail to add reject filter: the reject has been set a function")
	end
	for i = 1, #self.rejects do
		if self.rejects[i] == reject then
			error("Fail to add reject filter to system: the filter has existed")
			return
		end
	end
	self.rejects[#self.rejects + 1] = reject
	self:refresh()
end

function JuSystem:removeReject(reject)
	if type(self.requirements) == "function" then
		error("Fail to remove reject filter: the reject has been set a function")
	end
	for i = #self.rejects, 1, -1 do
		if self.rejects[i] == reject then
			table.remove(self.rejects, i)
			self:refresh()
			return true
		end
	end
	return false
end

function JuSystem:addEntity(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	self.entities[entity.id] = entity
end

function JuSystem:removeEntity(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	self.entities[entity.id] = nil
end

function JuSystem:eligible(entity)
	if not Types.isEntity(entity) then
		Types.error(entity, "entity")
	end
	if type(self.rejects) == "function" then
		do return not self.rejects(entity) end
	else
		for i = 1, #self.rejects do
			local reject = self.rejects[i]
			if entity:contains(reject) then
				return false
			end
		end
	end
	if type(self.requirements) == "function" then
		do return self.requirements(entity) end
	else
		for i = 1, #self.requirements do
			local requirement = self.requirements[i]
			if not entity:contains(requirement) then
				return false
			end
		end
	end
	return true
end

function JuSystem:getEntities()
	return self.entities
end

function JuSystem:foreach(update)
	if not update or type(update) ~= "function" then
		Types.error(update, "function")
	end
	for _, entity in pairs(self.entities) do
		if entity.active then
			update(entity)
		end
	end
end

function JuSystem:clearEntities()
	self.entities = {}
end

function JuSystem:activate()
	self.active = true
end

function JuSystem:deactivate()
	self.active = false
end

function JuSystem:isActive()
	return self.active
end

return JuSystem