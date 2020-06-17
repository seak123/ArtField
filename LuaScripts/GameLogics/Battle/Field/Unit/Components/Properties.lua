---@class Properties
local Properties = class("Properties")

Properties.type = {
    value = 0,
    ratio = 1,
    mix = 2
}

Properties.define = {
    hp = Properties.type.mix,
    speed = Properties.type.ratio,
    attack = Properties.type.mix,
    attackRange = Properties.type.value,
    attackTime = Properties.type.ratio,
    rage = Properties.type.value
}

function Properties:ctor(master)
    self.master = master
    self:Init(master.vo)
end

function Properties:Init(vo)
    -- init Properties
    for prop, type in pairs(Properties.define) do
        if type == Properties.type.value then
            self[prop] = vo[prop]
            self[prop .. "_add"] = 0
        elseif type == Properties.type.ratio then
            self[prop] = vo[prop]
            self[prop .. "_ratio"] = 0
        else
            self[prop] = vo[prop]
            self[prop .. "_add"] = 0
            self[prop .. "_ratio"] = 0
        end
    end
end

function Properties:GetProperty(name)
    if Properties.define[name] == nil then
        Debug.Error("GetProperty Wrong: undefined property [", name, "]")
        return 0
    end
    local type = Properties.define[name]
    if type == Properties.type.value then
        return self[name] + self[name .. "_add"]
    elseif type == Properties.type.ratio then
        return self[name] + self[name] * self[name .. "_ratio"] * 0.01
    else
        return self[name] + self[name .. "_add"] + self[name .. "_ratio"] * 0.01
    end
end

function Properties:ChangeProperty(name,value)
    if self[name] == nil then
        Debug.Warn("Try changing Invalid property [",name,"]");
    end
    self[name] = self[name] + value
end

return Properties
