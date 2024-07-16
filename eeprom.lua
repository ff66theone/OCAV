do
  local _secure = {}

  local component = require("component")
  _secure.component = component
  _secure.signatures = {}

  for i, j in component.list("filesystem") do
    local k = component.proxy(i), l
    if k.exists("/firmext.lua") then
      l=k.open("/firmext.lua")
      if component.isAvailable("data") then
        local m=k.read(l,32)
        local o=k.read(l,math.huge)
        local n=component.getPrimary("data")
        local q=n.sha256(o)
        for p in signatures do
          if m==q and q==p then
            o=n.inflate(o)
            pcall(load(o,"OCAV Firmware Extension","t",_secure))
          end
        end
      end
      local o=k.read(l,math.huge)
      _secure.nodata=true
      pcall(load(o,"OCAV Firmware Extension (nodata)","t",_secure))
    elseif k.exists("/OS.lua")
      l=k.open("/OS.lua")
      local o=k.read(l,math.huge)
      pcall(load(o,"MineOS IPL"))
    elseif k.exists("/init.lua")
      l=k.open("/init.lua")
      local o=k.read(l,math.huge)
      pcall(load(o,"init.lua"))
    end
  end
end
