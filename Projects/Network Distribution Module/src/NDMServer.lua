--[[
    Server Version: 
The goal of this module is to basically distribute network information.
There must be a specific amount of data sent in order for this module to activate.

Once that amount of information was sent, it will create a buffer that will
basically create other remotes and send it via them, which would connect back into the same
remote. 

This module will work best if you pre-specify amount of "virtual threads", instead
of automatically allowing it to create the remotes.

Possibly may make a version specifcally for Server-Server communication.
]]



local function createBin(parent)
    local folder = Instance.new("Folder")
    folder.Name = "NDM"
    folder.Parent = (parent or game:GetService("ReplicatedStorage"))
    return folder
end

local NDMBin = createBin() -- Specify a parent if you want it to go somewhere else.

local NDM = {}
NDM.__index = NDM
NDM.Networks = {
    Function = 0,
    Event = 1,
    -- Bindable = 2
}

local Networks = {
    [0] = function(parent, amount)
        for i=1, amount do
            local Thread = Instance.new("RemoteFunction")
            Thread.Name = tostring(i)
            Thread.Parent = parent
        end
    end
}


local function createNetworkBin(name, thread_amount, thread_type)
    if NDM.Networks
    if NDMBin[name] then return "Network Exists" end
    local bin = Instance.new("Folder")
    bin.Name = name
    bin.Parent = NDMBin
    return bin
end
----------------
function NDM.CreateNetwork(name, network_type) -- "
    local config = {}
    config.Name = name
    config.Bin = createNetworkBin(name, thread_amount, network_type)

    return setmetatable(config, NDMBin)
end

function NDM.RemoveNetwork(name)
    if NDMBin[name] then NDMBin[name]:Destroy() else return "No Network" end
end
----------------

return NDM