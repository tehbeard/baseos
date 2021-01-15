local ft = require("api/ft")

local pattern = {}
pattern.fn = function(length)
    place()
    for i=2,length,1 do
    	ft.forward()
    	place()
    end
end
pattern.args = {"Length"}

return pattern