do
  local _secure = {}

  local component = require("component")
  _secure.component = component
  _secure.signatures = {}

  local a, b = component.list("eeprom")
  _secure.eeprom = component.proxy(a)
  
  a, b = component.list("gpu")
  _secure.gpu = component.proxy(a)
  a, b = component.list("screen")
  _secure.gpu.bind(a, true)

  local com = {}

  --function _secure.consent(message,...)
    --local a = secure.gpu.allocateBuffer()

      --bitblt
  
    --secure.gpu.freeBuffer(a)
  --end

  -- Fake EEPROM to protect the true one
  local eeprom = {}

  eeprom.get = _secure.eeprom.get
  eeprom.getChecksum = _secure.eeprom.getChecksum
  eeprom.getData = _secure.eeprom.getData
  eeprom.getDataSize = _secure.eeprom.getDataSize
  eeprom.getLabel = _secure.eeprom.getLabel
  eeprom.getSize = _secure.eeprom.getSize
  eeprom.setLabel = _secure.eeprom.setLabel
  eeprom.setData = _secure.eeprom.setData

  eeprom.type = "eeprom"
  eeprom.address = _secure.eeprom.address

  function com.get(addr)
    if string.find(eeprom.address,addr,1,true) == 1 then
      return eeprom.address
    end
    return component.get(addr)
  end
  
  com.list = component.list

  function com.proxy(addr)
    if addr == eeprom.address then
      return eeprom
    end
    return component.proxy(addr)
  end

  function com.invoke(addr,command,...)
    if addr = eeprom.address then
      if command == "get" then
        return _secure.eeprom.get()
      elseif command == "set" then
        -- WARNING !!!
      elseif command = "getChecksum" then
        return _secure.eeprom.getChecksum()
      elseif command == "getData" then
        return _secure.eeprom.getData()
      elseif command == "getDataSize" then
        return _secure.eeprom.getDataSize()
      elseif command == "getLabel" then
        return _secure.eeprom.getLabel()
      elseif command == "getSize" then
        return _secure.eeprom.getSize()
      elseif command == "makeReadOnly" then
        -- WARNING !!!
      elseif command == "setLabel" then
        _secure.eeprom.setLabel(...)
      elseif command == "setData" then
        _secure.eeprom.setData(...)
      end
      return nil
    end
    return component.invoke(addr,command,...)
  end

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
