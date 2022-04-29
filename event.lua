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

function connections.new(id)
    local connection = {}

    connection.id = id or uuid()
    connection.f = nil

    function connection:disconnect()
        self.connection = nil
    end

    return setmetatable(connection, connections)
end

return function(event_name)
    local self = {}

    self.name = event_name
    self.connections = {}

    function self:terminateAllConnections()
        local numConnections = #self.connections
        for i = 0, numConnections do self.connections[i] = nil end
    end

    function self:getConnections()
        return self.connections
    end

    function self:connect(f, id, priority)
        local connection = connections.new(id)
        id = id or tostring(#self.connections+1)

        connection.f = f
        connection.event = self

        function connection:disconnect()
            self.connection[id] = nil
        end

        self.connections[id] = connection
        return connection
    end

    function self:fire()
        for _,f in pairs(self.connections) do f.connection()end
    end

    return setmetatable(self, events)
end
