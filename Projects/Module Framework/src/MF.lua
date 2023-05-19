local MFramework = {}
local Services = {}


------------------------ Types

type Service = {
    Name: string,
    [any]: any
}

------------------------ Local Functions

local function isServce(name)
    return Services[name] ~= nil
end

------------------------ Framework Functions

function MFramework.CreateService(service: Service): Service
    Services[server.Name] = service
    return service
end

function MFramework.GetService(service_name): Service
    if isServce(name) then
        return Services[service_name]
    end
end

function MFramework.Start()
    local AfterAll = {}
    for service_name, service in pairs(Services) do
        if service["MFInit"] then service:MFInit() end
        if serice["MFStarted"] then table.insert(AfterAll, service) end
        
    end
    ----- After all modules are initalized. On the specific side (server or client)
    for _, s in next, AfterAll do
        s:MFStarted()
    end
end

return MFramework