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

local function identifyMethod(network_type)
    if self.network_type == "RemoteFunction" then return "OnServerInvoke", "Invoke"
    elseif self.network_type == "RemoteEvent" then return "OnServerEvent", "Fire" end
end

local function identifyBindable(network_type)
    if self.network_type == "RemoteFunction" then return "BindableFunction"
    elseif self.network_type == "RemoteEvent" then return "BindableEvent" end
end

local NDMBin = createBin() -- Specify a parent if you want it to go somewhere else.

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

local function gaurdConfiguration(config)
    if (config.method_name or config.connection_name or config.Threads or config.Bin) == nil then return true else return false end
end

----------------
function NDM.CreateNetwork(name, thread_amount, network_type)
    local config = {}
    config.Name = name
    config.Bin = createNetworkBin(name, thread_amount, network_type)
    config.method_name, config.connection_name = identifyMethod(network_type)
    config.OnRecieved = Instance.new(config.method_name)
    config.Threads = config.Bin:GetChildren()
    config.CurrentThread = 1
    config.ThreadAmount = thread_amount
    config.Connections = {}
    setmetatable(config, NDMBin)
    if config:VerifyConfigurationFault() then config:SoftDestroy(); return end
    config:Establish()
    Networks[name] = config
    return config
end

function NDM.RemoveNetwork(name)
    if Networks[name] then Networks[name]:Destroy() else return "No Network" end
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
    self = nil
end

function NDM:SoftDestroy()
    self.OnRecieved:Destroy()
    self.Bin:Destroy()
    self = nil
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

function NDM:VerifyConfigurationFault()
    if gaurdConfiguration(self) then self:Destroy(); return true end
end


return NDM