--双向链表节点
local listNode = {}

listNode.value = nil
listNode.next = nil
listNode.prev = nil

--节点构造函数
function listNode:new(object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

--双向链表迭代器，保存一个指向的listNode和归属的list
listIterator = {}
listIterator.node = nil
listIterator.owner = nil

function listIterator:new(owner)
    local object = {}
    setmetatable(object, self)
    self.__index = self
    object.owner = owner
    return object
end

function listIterator:next(count)
    count = count or 1
    for i = 1, count do
        if self.node ~= nil then
            self.node = self.node.next
        else
            return false
        end
    end

    return self.node ~= nil
end

function listIterator:prev(count)
    count = count or 1
    for i = 1, count do
        if self.node ~= nil then
            self.node = self.node.prev
        else
            return false
        end
    end
    return self.node ~= nil
end

function listIterator:value()
    if self.node ~= nil then
        return self.node.value
    end
    return nil
end

function listIterator:erase()
    if self.owner ~= nil then
        self.owner.erase()
    end
end

function listIterator:valid()
    return self.owner ~= nil and self.node ~= nil
end

--双向链表
list = {}

list.first = nil --指向第一个节点
list.last = nil --指向最后一个节点

--双向链表构造函数
function list:new(object)
    object = object or {}
    setmetatable(object, self)
    self.__index = self
    return object
end

function list:push(value)
    if self.first == nil or self.last == nil then
        self.first = listNode:new()
        self.last = self.first
        self.last.value = value
        return
    end

    local newNode = listNode:new()
    newNode.prev = self.last
    newNode.value = value

    self.last.next = newNode
    self.last = newNode
end

-- 丛链表的后端推出一个值
function list:pop()
    if self.last == nil then
        return nil
    end

    local value = self:back()

    local prevNode = self.last.prev
    if prevNode == nil then
        self.first = nil
        self.last = nil
    else
        prevNode.next = nil
        self.last = prevNode
    end
    return value
end

function list:pushFront(value)
    if self.first == nil or self.last == nil then
        self.first = listNode:new()
        self.last = self.first
        self.last.value = value
        return
    end

    local newNode = listNode:new()
    newNode.value = value
    newNode.next = self.first
    self.first.prev = newNode
    self.first = newNode
end

function list:popFront()
    if self.first == nil then
        return nil
    end

    local front = self:front()

    local nextNode = self.first.next
    if nextNode == nil then
        self.first = nil
        self.last = self.first
    else
        nextNode.prev = nil
        self.first = nextNode
    end
    return front
end
--链表最前端的值
function list:front()
    if self.first == nil then
        return nil
    end
    return self.first.value
end
--链表最后端的值
function list:back(  )
    if self.last == nil then
        return nil
    end
    return self.last.value
end
--判断链表是否为空
function list:empty(  )
    return self.first == nil or self.last == nil
end
--清空链表
function list:clear(  )
    self.first = nil
    self.last = nil
end

function list:Begin()
    local itr = listIterator:new(self)
    itr.node = self.first
    return itr
end

function list:End()
    local itr = listIterator:new(self)
    itr.node = self.last
    return itr
end

-- 从链表中搜索某个值，找到就返回一个迭代器
function list:find(v, start)
	if start == nil then
		start = self:Begin()
	end

	repeat
		if v == start:value() then
			return start
		end
	until start:next() == false

	return nil
end

-- 从链表中反向搜索某个值，找到就返回一个反向迭代器
function list:rfind(v, start)
	if start == nil then
		start = self:End()
	end

	repeat
		if v == start:value() then
			return start
		end
	until start:prev() == false

	return nil
end

-- 根据迭代器从链表中删除一个节点，同时会改变itr指向为当前值的前一个
function list:erase(itr)

	if nil == itr or nil == itr.node or
		itr.owner ~= self then
		return itr
	end

	local nextItr = listIterator:new(self)
	nextItr.node = itr.node
	nextItr:next()

	if itr.node == self.first then
		self:popFront()
	elseif itr.node == self.last then
		self:pop()
	else
		local prevNode = itr.node.prev
		local nextNode = itr.node.next

		if prevNode ~= nil then
			prevNode.next = nextNode
		end

		if nextNode ~= nil then
			nextNode.prev = prevNode
		end
	end

	itr.owner = nil
	itr.node = nil

	return nextItr
end

-- 删除链表中的一个确定的值，先找到迭代器，然后再通过迭代器删除
function list:eraseValue(value)
	local itr = self:find(value)
	self:erase(itr)
end

-- 删除链表中所有相同的值
function list:erase_all(value)
	local itr = self:find(value)
	while itr ~= nil and itr:valid() do
		itr = self:erase(itr)
		itr = self:find(value, itr)
	end
end

-- 根据迭代器向双向链表中某个位置后插入一个新的值
function list:insert(itr, value)
	if nil == itr or nil == itr.node or
		itr.owner ~= self then
		return
	end

	local result_itr = listIterator:new(self)

	if itr.node == self.last then
		self:push(value)
		result_itr.node = self.last
	else
		local prevNode = itr.node
		local nextNode = itr.node.next
		local newNode = listNode:new()
		newNode.value = value
		prevNode.next = newNode
		nextNode.prev = newNode
		newNode.next = nextNode
		newNode.prev = prevNode

		result_itr.node = newNode
	end

	return result_itr
end

-- 根据迭代器向双向链表中某个位置前插入一个新的值
function list:insertBefore(itr, value)
	if nil == itr or nil == itr.node or
		itr.owner ~= self then
		return
	end

	local result_itr = listIterator:new(self)

	if itr.node == self.first then
		self:pushFront(value)
		result_itr.node = self.first
	else
		local prevNode = itr.node.prev
		local nextNode = itr.node
		local newNode = listNode:new()
		newNode.value = value
		prevNode.next = newNode
		nextNode.prev = newNode
		newNode.next = nextNode
		newNode.prev = prevNode

		result_itr.node = newNode
	end

	return result_itr
end

-- for循环中使用到的正向迭代器函数实现
function ilist(l)

	local itr_first = listIterator:new(l)
	itr_first.node = listNode:new()
	itr_first.node.next = l.first

	local function ilist_it(itr)

		itr:next()
		local v = itr:value()

		if v ~= nil then
			return v, itr
		else
			return nil
		end

	end

	return ilist_it, itr_first
end

-- for循环中使用到的反向迭代器函数实现
function rilist(l)

	local itr_last = listIterator:new(l)
	itr_last.node = listNode:new()
	itr_last.node.prev = l.last

	local function rilist_it(itr)

		itr:prev()
		local v = itr:value()

		if v ~= nil then
			return v, itr
		else
			return nil
		end

	end

	return rilist_it, itr_last
end

-- 双向链表的打印函数
function list:Print()
	for v in ilist(self) do
		print(tostring(v))
	end
end

-- 双向链表的大小
function list:size()
	local count = 0

	for v in ilist(self) do
		count = count + 1
	end

	return count
end

-- 双向链表的拷贝
function list:clone()
	local newList = list:new()
	for v in ilist(self) do
		newList:push(v)
	end
	return newList
end
