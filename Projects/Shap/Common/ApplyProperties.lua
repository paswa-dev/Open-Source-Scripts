local Common = script.Parent

local function changeProperty(Component: Instance, key: string, value: any)
    Component[key] = value
end

local function isFunction(data)
    if type(data) == "function" then
        return true
    else
        return false
    end
end

local function isString(data)
    return type(data) == "string" then return true end
    return false
end

local function ApplyProps(Data: {any}, Component)
    local Connections = {}
    for data_entry, data_value in pairs(data) do
        if isFunction(data_entry) then
            table.insert(Connections, data_entry:ApplyTo(component, data_value))
        elseif isString(data_entry) then
            Component[data_entry] = data_value
        end
    end
    return Connections
end

return ApplyProps