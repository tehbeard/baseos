local ft = require("/api/ft")
local ptn_line = require("./line").fn

local pattern = {}
pattern.fn = function(length,width) 
    ft.up()
    ptn_line(length-1)
    ft.forward()
    turtle.turnRight()
    ptn_line(width-1)
    ft.forward()
    turtle.turnRight()
    ptn_line(length-1)
    ft.forward()
    turtle.turnRight()
    ptn_line(width-1)
    ft.forward()
    turtle.turnRight()
end
pattern.args = {"Length","Width"}

return pattern