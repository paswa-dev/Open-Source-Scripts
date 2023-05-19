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

local RS = game:GetService("ReplicatedStorage")

local function createBin(parent)
    local folder = Instance.new("Folder")
    folder.Name = "NDM"
    folder.Parent = (parent or RS)
    return folder
end

local NDMBin = createBin() -- Specify a parent if you want it to go somewhere else.
local FastSignal = require(rs:FindFirstChild("FastSignal", true))
if not FastSignal then error("Missing Required Dependency: FastSignal") return nil end 

local NDM = {}
local Networks = {}
NDM.__index = NDM

local function createNetworkBin(name, thread_amount, thread_type)
    if NDMBin[name] then return "Overlapping Network Exists" end
    local bin = Instance.new("Folder")
    bin.Name = name
    bin.Parent = NDMBin

    for i=1, amount do
        local Thread = Instance.new(thread_type)
        Thread.Name = tostring(i)
        Thread.Parent = parent
    end

    return bin
end

----------------
function NDM.CreateNetwork(name, thread_amount, network_type)
    local config = {}
    config.Name = name
    config.Bin = createNetworkBin(name, thread_amount, network_type)
    config.OnRecieved = FastSignal.new()
    ---
    config.network_type = network_type
    config.thead_amount = thread_amount
    setmetatable(config, NDMBin)
    config.Connections = config:EstablishConnections()
    Networks[name] = config
    return config
end

function NDM.RemoveNetwork(name)
    if NDMBin[name] then NDMBin[name]:Destroy() else return "No Network" end
end

function NDM.GetNetwork(name)
    return Networks[name]
end
----------------

function NDM:Fire(...)

end

function NDM:Establish()
    local Connections = {}
    local connection_name
    if self.network_type == "RemoteFunction" then connection_name = "OnServerInvoke" 
    elseif self.network_type == "RemoteEvent" then connection_name = "OnServerEvent" end
    for _, thread_object in pairs(self.Bin:GetChildren()) do
        table.insert(Connections, thread_object[connection_name](function(...)
            self.OnRecieved:Fire(...) -- FInd a way to return data...
        end))
    end
    return 
end

function NDM:Destroy()

end


return NDM