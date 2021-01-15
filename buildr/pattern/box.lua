local ft = require("api/ft")
local ptn_fence = require("./fence").fn
local ptn_floor = require("./floor").fn

local pattern = {}
pattern.fn = function(length,width,height)
    ptn_floor(length,width)
    if odd(width) then
    	-- turn around 180
    	turtle.turnRight()
    	turtle.turnRight()
    else
    	turtle.turnRight()
    	l = length
    	length = width
    	width = l
    end

    -- Do walls
    for y=1,height,1 do 
        ptn_fence(length,width)
    end

    ft.up()
    ptn_floor(length,width)
end
pattern.args = {"Length","Width","Height"}

return pattern