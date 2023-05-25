local Shap = {}
--[[
Notes:
    Make a seperate folder/directory with types 
]]

local Root = script.Parent
local Common = Root.Common
local BaseTypes, ApplyProperties = require(Common.BaseTypes), require(Common.ApplyProperties)

function Shap.init()

end

function Shap.new(class_name: string) -- Possibly return a controlled component
    return function(classData)
        local CurrentDataModel = BaseTypes[class_name]
        local OK, Component = pcall(Instance.new, class_name)
        if not OK then error(Component) end
        if not CurrentDataModel then Component:Destroy(); error(string.format("Could not find Class %s within DataModels", class_name)) end
        
        for key, value in pairs(CurrentDataModel) do
            Component[key] = value
        end

        ApplyProperties(classData, Component)
        
        return Component

    end
end

function Shap.ViewTypes()
    local allTypes = {}
    for key, value in pairs(BaseTypes) do
        table.insert(allTypes, key)
    end
    return key
end

return Shap