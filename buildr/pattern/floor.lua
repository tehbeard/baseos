local ft = require("/api/ft")
local ptn_line = require("./line").fn

local pattern = {}
pattern.fn = function(length,width)
    for w = 1,width,1 do
    	ptn_line(length)
    	if w ~= width then
        	if odd(w) then
    	    	turtle.turnRight()
        		ft.forward()
        		turtle.turnRight()
        	else
        		turtle.turnLeft()
     		    ft.forward()
    		    turtle.turnLeft()
    	    end
        end
    end
end
pattern.args = {"Length","Width"}

return pattern
