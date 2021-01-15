local chest = {}
chest.desc = "Use a placeable chest/shulker/crate to restock"
chest.chestLoc = 16
chest.restock = function(slot)
	left = turtle.getItemCount(slot)
    spc = turtle.getItemSpace(slot)
	if left < 9 then
		turtle.select(chest.chestLoc)
		while turtle.digUp() do sleep(0) end
        turtle.placeUp()
        turtle.select(slot)
        turtle.suckUp(spc)

        turtle.select(chest.chestLoc)
        turtle.dropUp()
		
		turtle.digUp()
		turtle.select(slot)
	end
end

return chest