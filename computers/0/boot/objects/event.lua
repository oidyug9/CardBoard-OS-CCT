local event = {}
event.__index = event

function event.new()
  local self = setmetatable({},event)
  self.subscribers = {}

  return self
end

function event:subscribe(func)
  self.subscribers[#self.subscribers + 1]=func
end

function event:fire( ... )
  for idx, func in pairs(self.subscribers) do 
    func( ... )
  end
end

return event
