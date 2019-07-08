local Types = {}

function Types.isComponent(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isComponent ~= nil
end

function Types.isEntity(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEntity ~= nil
end

function Types.isSystem(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isSystem ~= nil
end

function Types.isEvent(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEvent ~= nil
end

function Types.isEntityManager(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEntityManager ~= nil
end

function Types.isEventManager(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEventManager ~= nil
end

function Types.isWorld(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isWorld ~= nil
end

function Types.typeinfo(obj)
	if type(obj) ~= "table" then return type(obj) end
	if Types.isComponent(obj) then return "component" end
	if Types.isEntity(obj) then return "entity" end
	if Types.isSystem(obj) then return "system" end
	if Types.isEvent(obj) then return "event" end
	if Types.isWorld(obj) then return "world" end
	if Types.isEntityManager(obj) then return "entitymanager" end
	if Types.isEventManager(obj) then return "eventmanager" end
	return "table"
end

function Types.error(obj, right)
	error(string.format("Attempt to pass a wrong type: need a %s value instead of %s", Types.typeinfo(right), Types.typeinfo(obj)), 1)
end

return Types