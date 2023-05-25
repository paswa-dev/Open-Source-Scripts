local Shap = {}

function Shap.init()

end

function Shap.new(class_name: string)
    return function(classData)
        local OK, err, UI = pcall(Instance.new, class_name)
        assert(OK, err)
        gays
        bad
    end
end

return Shap