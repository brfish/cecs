local BASEDIR = (...):match("(.-)[^%.]+$")
local Entity = require(BASEDIR.."entity")

local EntityManager = class("cherry_ecs_EntityManager")

function EntityManager:initialize()
	self.entities = {}
	self.entityCount = 0

	self.filter = {}
end

function EntityManager:create()
	local entity = Entity()
	self.entities[entity] = entity
	self.entityCount = self.entityCount+1
	--self.entities[#self.entities+1] = entity
	return entity
end

function EntityManager:destroy(entity)
	if self.entities[entity] then
		self.entities[entity] = nil
		self.entityCount = self.entityCount-1
	else
		error("Failed to destroy the entity: Could not find the entity")
	end
end

function EntityManager:addComponentToEntity(entity, component)
	if self.entities[entity] then
		local key, ctor, value = component[1], component[2], component[3]
		if self.entities[entity][key] ~= nil then
			error("Failed to add the component to the entity: Could not add a existed component to the entity")
		end
		if value ~= nil then
			self.entities[entity][key] = ctor(unpack(value))
		else
			self.entities[entity][key] = ctor()
		end
	else
		error("Failed to add the component to the entity: The entity must be added to the entity manager before trying to add component to it")
	end
end

function EntityManager:removeComponentFromEntity(entity, component)
	if self.entities[entity] then
		if self.entities[entity][component] then
			self.entities[entity][component] = nil
		else
			error("Failed to remove the component from the entity: The entity did not have the component")
		end
	else
		error("Failed to remove the component from the entity: The entity must be added to the entity manager before trying to remove component from it")
	end		
end

function EntityManager:assign(entity, component)
	if self.entities[entity] then
		local key, ctor, value = component[1], component[2], component[3]
		if self.entities[entity][key] ~= nil then
			error("Failed to assign the entity: Could not add a existed component to the entity")
		end
		if value ~= nil then
			self.entities[entity][key] = ctor(unpack(value))
		else
			self.entities[entity][key] = ctor()
		end
	else
		error("Failed to assign the entity: The entity must be added to the entity manager before trying to assign component to it")
	end
end

function EntityManager:process(filter, func)
	for _, entity in pairs(self.entities) do
		local isLegal = true
		for i = 1, #filter do
			if entity[filter[i]] == nil then
				isLegal = false
				break
			end
		end
		if isLegal then
			func(entity)
		end
	end
end
--   Reload each function
--[[function EntityManager:each(...)
	local selectedEntity = {}
	for _, entity in pairs(self.entities) do
		local isLegal = true
		for _, component in ipairs({...}) do
			if entity[component] == nil then
				isLegal = false
				break
			end
		end
		if isLegal then
			selectedEntity[#selectedEntity+1] = entity
			--utils.append(selectedEntity, entity)
		end
	end
	return selectedEntity
end]]

function EntityManager:each(...)
	local n = select("#", ...)
	local processFunction = select(n, ...)
	for _, entity in pairs(self.entities) do
		local isLegal = true
		for i = 1, n-1 do
			local component = select(i, ...)
			if entity[component] == nil then
				isLegal = false
				break
			end
		end
		if isLegal then
			processFunction(entity)
		end
	end
	
end

function EntityManager:exists(entity)
	return self.entities[entity] ~= nil
end

return EntityManager