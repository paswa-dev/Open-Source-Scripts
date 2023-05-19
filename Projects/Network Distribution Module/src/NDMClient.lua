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

local function getBin(parent)
    return (parent or RS):WaitForChild("NDM")
end

local function identifyMethod(network_type)
    if self.network_type == "RemoteFunction" then return "OnServerInvoke", "Invoke"
    elseif self.network_type == "RemoteEvent" then return "OnServerEvent", "Fire" end
end

local function identifyBindable(network_type)
    if self.network_type == "RemoteFunction" then return "BindableFunction"
    elseif self.network_type == "RemoteEvent" then return "BindableEvent" end
end

local NDMBin = getBin() -- Specify a parent path if you have a custom directory.

local function getNetworkBinInformation(name)
    local bin = NDMBin[name]
    local information = {}
    information.Bin = bin
    information.Threads = bin:GetChildren()
    information.ThreadAmount = #information.Threads
    information.network_type = information.Threads[1].ClassName
    return information
end

local NDM = {}
local Networks = {}
NDM.__index = NDM

----------------
function NDM.FetchNetwork(name)
    local networkInformation = getNetworkBinInformation(name)
    local config = {}
    config.Name = name
    config.Bin = networkInformation.Bin
    config.method_name, config.connection_name = identifyMethod(networkInformation.network_type)
    config.Threads = networkInformation.Threads
    config.ThreadAmount = networkInformation.ThreadAmount
    config.OnRecieved = Instance.new(config.method_name)
    config.CurrentThread = 1
    config.Connections = {}
    setmetatable(config, NDMBin)
    config:Establish()
    Networks[name] = config
    return config
end

function NDM.GetNetwork(name)
    return Networks[name]
end
----------------

function NDM:Fire(...)
    -- This fires the remote event or function.
    local thread_object = self.Threads[self.CurrentThread]
    thread_object[self.method_name](thread_object, ...)
    self:NextThread()
end

function NDM:Establish()
    -- This creates the connections. Then sets them up to basically return a response based on the fired bindable event/function.
    
    for _, thread_object in pairs(self.Bin:GetChildren()) do
        table.insert(self.Connections, thread_object[self.connection_name](function(...)
            return response = self.OnRecieved[self.method_name](OnRecieved, ...)
        end))
    end
end

function NDM:Destroy()
    for _, connection in next, self.Connections do
        connection:Disconnect()
    end
    self.OnRecieved:Destroy()
    self.Bin:Destroy()
    Networks[self.Name] = nil
end

function NDM:NextThread()
    local _next = self.CurrentThread + 1
    if _next > self.ThreadAmount then
        self.CurrentThread = 1
        return 1
    end
    self.CurrentThread = _next
    return _next
end


return NDM