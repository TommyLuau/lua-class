return function(class_name)
    local self = {}
    self.class = class_name

    return function(properties)
        if properties then
            for i,v in pairs(properties) do self[i] = v end
        end
        
        return setmetatable(self)
    end
end