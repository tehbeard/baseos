local slot = {}
slot.desc = "random"
function slot.setSlot()
    turtle.select(math.random(1,15))
end

return slot