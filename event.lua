local events = {}
events.__index = events

local connections = {}
connections.__index = {}

local random = math.random
local function uuid()
    local uuid ='xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'

    return string.gsub(uuid, '[xy]', function (c)
        local v = (c == 'x') and random(0, 0xf) or random(8, 0xb)
        return string.format('%x', v)
    end)
end

local function newConnection(id)
    local self = {}

    self.id = id or uuid()
    self.connection = nil

    return setmetatable(self, connections)
end

return function(event_name)
    local self = {}

    self.name = event_name
    self.connections = {}

    function self:terminateConnection(connectionId)
        if not connectionId then error('Connection ID has not been provided.') end        
        if not self.connections[connectionId] then error("Invalid Connection ID") end

    end

    function self:terminateAllConnections()
        local numConnections = #self.connections
        for i = 0, numConnections do self.connections[i] = nil end
    end

    function self:getConnections()
        
    end

    return setmetatable(self, events)
end
