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
    ---- Private
    local Pin = {}
    local isRunning = false
    ---- Public
    Pin.pin = MakePinInfo(name, adornee, nil, {})

    function Pin:AddChild(element: Instance)
        table.insert(Pin.pin.Children, element)
    end
    
    function Pin:UpdateChildren(callback)
        for _, child in next, Pin.pin.Children do
            callback(child)
        end
    end
    
    function Pin:Enable()
        if isRunning then return end
        isRunning = true
        while task.wait() do 
            if not isRunning then break end
            local NextPos = UpdatePinPosition(Pin.pin)
            Pin:UpdateChildren(function(child)
                child["Position"] = UDim2.fromOffset(NextPos.X, NextPos.Y)
            end)
        end
    end
    
    function Pin:Disable()
        if not isRunning then return end
        isRunning = false
    end

    return Pin
end

return pin