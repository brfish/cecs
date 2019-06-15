local BASEDIR = (...):match("(.-)[^%.]+$")
local class = require(BASEDIR .. "class")

local COrderedTable = class("cecs_orderedtable")

local CIterator = class("cecs_iterator")

function CIterator:init(itable)
	self.current = 0
	self.table = itable
end

function CIterator:next()
	if self.current >= #self.table then
		return nil
	end
	self.current = self.current + 1
	return true
end

function CIterator:get()
	if self.current <= #self.table then
		return self.table[self.current]
	end
	return nil
end

function COrderedTable:init()
	self.data = {}
	self.index = {}
	self.tablesize = 0
end

function COrderedTable:insert(data)
	self.tablesize = self.tablesize + 1
	self.data[tablesize] = data
	if not self.index[data] then
		self.index[data] = 1
	else
		self.index[data] = self.index[data] + 1
	end
end

function COrderedTable:remove(dataOrIndex, ctype)
	if type(dataOrIndex) == "number" then
		if ctype and ctype == "index" then
			if 0 < dataOrIndex and dataOrIndex <= self.tablesize then
				self.index[self.data[dataOrIndex]] = self.index[self.data[dataOrIndex]] - 1
				if self.index[self.data[dataOrIndex]] <= 0 then
					self.index[self.data[dataOrIndex]] = nil
				end
				table.remove(self.data, dataOrIndex)
				self.tablesize = self.tablesize - 1
			end
		end
	end
	if self.index[dataOrIndex] then
		local count = 0
		for i = #self.data, 1, -1 do
			if self.data[i] == dataOrIndex then
				count = count + 1
				table.remove(self.data, i)
				if count >= self.index[dataOrIndex] then
					break
				end
			end
		end
		self.index[dataOrIndex] = nil
	end
end

function COrderedTable:clear()
	self.data = {}
	self.index = {}
	self.tablesize = 0
end


function COrderedTable:exists(data)
	return self.index[data] ~= nil
end

function COrderedTable:counts(data)
	if self.index[data] then
		return self.index[data]
	end
	return 0
end

function COrderedTable:sort(cmp)
	if type(cmp) == "function" then
		table.sort(self.data, cmp)
	elseif type(cmp) == "string" then
		if cmp == "less" then
			table.sort(self.data, function(a, b) return a < b end)
		elseif cmp == "greater" then
			table.sort(self.data, function(a, b) return a > b end)
		end
	end
end

function COrderedTable:iterator()
	return CIterator.new(self.data)
end

return COrderedTable