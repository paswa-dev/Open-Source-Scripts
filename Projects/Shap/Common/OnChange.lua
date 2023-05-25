local function OnChange(property_name)
    local payload = {}
    payload.property_name = property_name
    payload.signal = nil

    function payload:ApplyTo(Component, callback)
        payload.signal = Component[payload.property_name]:GetPropertyChangedSignal:Connect(callback)
        return payload.signal
    end

    return payload
end