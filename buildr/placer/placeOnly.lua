local placer = {}
placer.desc = "place beneath"
function placer.place(slot)
    turtle.placeDown()
end

return placer