local JuTypes = {}

function JuTypes.isComponent(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isComponent ~= nil
end

function JuTypes.isEntity(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEntity ~= nil
end

function JuTypes.isSystem(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isSystem ~= nil
end

function JuTypes.isEvent(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEvent ~= nil
end

function JuTypes.isEntityManager(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEntityManager ~= nil
end

function JuTypes.isEventManager(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isEventManager ~= nil
end

function JuTypes.isWorld(obj)
	if type(obj) ~= "table" then return false end
	return obj.__isWorld ~= nil
end

function JuTypes.typeinfo(obj)
	if type(obj) ~= "table" then return type(obj) end
	if JuTypes.isComponent(obj) then return "component" end
	if JuTypes.isEntity(obj) then return "entity" end
	if JuTypes.isSystem(obj) then return "system" end
	if JuTypes.isEvent(obj) then return "event" end
	if JuTypes.isWorld(obj) then return "world" end
	if JuTypes.isEntityManager(obj) then return "entitymanager" end
	if JuTypes.isEventManager(obj) then return "eventmanager" end
	return "table"
end

function JuTypes.error(obj, right)
	error(string.format("Attempt to pass a wrong type: need a %s value instead of %s", JuTypes.typeinfo(right), JuTypes.typeinfo(obj)), 1)
end

return JuTypes