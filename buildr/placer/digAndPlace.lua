local placer = {}
placer.desc = "place beneath"
function placer.place(slot)
    turtle.digDown()
    turtle.placeDown()
end

return placer