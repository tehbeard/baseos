local ft = require("/api/ft")
local ptn_line = require("./line").fn

local pattern = {}
pattern.fn = function(length,height)
    for h = 1,height,1 do
    	ptn_line(length)
    	if h ~= height then
    	    ft.up()
    	    turtle.turnRight()
    	    turtle.turnRight()
        end
    end
end
pattern.args = {"Length","Height"}

return pattern