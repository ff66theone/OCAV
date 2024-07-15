local av = {}

if G._AV then
	return nil
end

G._AV = true

require("component") -- Ensure the component library is loaded
local oldComponent = package.loaded["component"]

function av.load()
	local newComponent = oldComponent
