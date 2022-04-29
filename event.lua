local events = {}
events.__index = events

local connections = {}
connections.__index = {}

function table_print (tt, indent, done)
    done = done or {}
    indent = indent or 0
    if type(tt) == "table" then
      for key, value in pairs (tt) do
        io.write(string.rep (" ", indent)) -- indent it
        if type (value) == "table" and not done [value] then
          done [value] = true
          io.write(string.format("[%s] => table\n", tostring (key)));
          io.write(string.rep (" ", indent+4)) -- indent it
          io.write("(\n");
          table_print (value, indent + 7, done)
          io.write(string.rep (" ", indent+4)) -- indent it
          io.write(")\n");
        else
          io.write(string.format("[%s] => %s\n",
              tostring (key), tostring(value)))
        end
      end
    else
      io.write(tt .. "\n")
    end
  end

function connections.new(id)
    local self = {}

    self.id = id
    self.f = nil
    self.fireOnDisconnect = false

    function self:fire()
        coroutine.wrap(self.f)
    end

    return setmetatable(self, connections)
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
            self.f = nil
            self.connection[id] = nil
        end

        self.connections[id] = connection
        return connection
    end

    function self:disconnect(id)
        if not id then
            for _,connection in pairs(self.connections) do connection:disconnect() end
        else
            self.connections[id]:disconnect()
        end
    end

    function self:fire(id)
        if not id then
            for _,connection in pairs(self.connections) do connection:fire() end
        else
            self.connections[id]:fire()
        end
    end



    self = setmetatable(self, {
        __index = function()
            
        end,

        __tostring = function()
            
        end
    })
    events[self.name] = self

    return self
end
