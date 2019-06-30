
local Types = {}

function Types.isComponent(obj)
	return obj.__isComponent ~= nil
end

function Types.isEntity(obj)
	return obj.__isEntity ~= nil
end

function Types.isSystem(obj)
	return obj.__isSystem ~= nil
end

function Types.isEvent(obj)
	return obj.__isEvent ~= nil
end

function Types.isEntityManager(obj)
	return obj.__isEntityManager ~= nil
end

function Types.isEventManager(obj)
	return obj.__isEventManager ~= nil
end

function Types.isWorld(obj)
	return obj.__isWorld ~= nil
end

function Types.typeinfo(obj)
	if Types.isComponent(obj) then return "component" end
	if Types.isEntity(obj) then return "entity" end
	if Types.isSystem(obj) then return "system" end
	if Types.isEvent(obj) then return "event" end
	if Types.isWorld(obj) then return "world" end
	if Types.isEntityManager(obj) then return "entitymanager" end
	if Types.isEventManager(obj) then return "eventmanager" end
	return type(obj)
end

return Types