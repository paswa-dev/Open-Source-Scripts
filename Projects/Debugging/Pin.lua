local pin = {}

type PinData = {
    Children: {any}
}

type PinInfo = {
    Name : string,
    Adornee: Instance | Vector3,
    PinData : PinData,
    [any]: any,
}

local function UpdatePinPosition(pin: PinInfo)
    -- Do stuff
end

local function MakePinData(...): PinData
    local data = {
        Children = {}
    }
    for _, v in next, {...} do table.insert(data.Children, v) end
    return data
end

local function MakePinInfo(name : string, adornee: Instance | Vector3 | nil, PinData : PinData | nil, misc: {any} | nil) : PinInfo
    local info = {
        Name = name,
        Adornee = adornee or Vector3.zero,
        PinData = PinData or MakePinData(),
    }
    for i, v in pairs(misc) do if not info[i] then info[i] = v end end
    return info
end

function pin.new(name: string, adornee : Instance | Vector3 | nil)
    local ThisPinConfig = {}
    ThisPinConfig.pin = MakePinInfo(name, adornee, nil, {
        isRunning = false
    })
    setmetatable(ThisPinConfig, {__index = pin})
    ThisPinConfig:Enable()
    return ThisPinConfig
end

function pin:AddChild(element: Instance)
    table.insert(self.pin.Children, element)
end

function pin:UpdateChildren(callback)
    for _, child in next, self.pin.Children do
        callback(child)
    end
end

function pin:Enable()
    if self.Pin.isRunning then return end
    self.Pin.isRunning = true
    while task.wait() do 
        if not self.Pin.isRunning then break end
        local NextPos = UpdatePinPosition(self.pin)
        self:UpdateChildren(function(child)
            child["Position"] = UDim2.fromOffset(NextPos.X, NextPos.Y)
        end)
    end
end

function pin:Disable()
    if not self.Pin.isRunning then return end
    self.Pin.isRunning = false
end

return pin