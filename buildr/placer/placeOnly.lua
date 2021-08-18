local placer = {}
placer.desc = "place only"
function placer.place(slot)
    turtle.placeDown()
end

return placer