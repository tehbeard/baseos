local inv = {}
inv.desc = "Use local inventory and restack"
function inv.restock(slot)
	left = turtle.getItemCount(slot)
	if left < 9 then
		for i = 1,16,1 do 
			turtle.select(i)
			turtle.transferTo(slot,64)
		end
	end
	turtle.select(restock)
	turtle.digDown()
	turtle.placeDown()
end

return inv