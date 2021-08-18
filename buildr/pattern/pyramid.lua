local ft = require("/api/ft")
local ptn_fence = require("./fence").fn

local pattern = {}
pattern.fn = function(length,width)
    l = length
    w = width

    while l > 1 and w > 1 do
    ptn_fence(l,w)
    ft.forward()
    turtle.turnRight()
    ft.forward()
    turtle.turnLeft()
    l = l - 2
    w = w - 2
    end
    ft.up()
    programs.floor[1](l,w)
    end
pattern.args = {"Length","Width"}

return pattern