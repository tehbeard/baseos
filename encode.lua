--[[
    Program to encode crafting patterns into a CC turtle
]]
local fh = fs.open("crafting.luadb","r")
local db = textutils.unserialize(fh.readAll())
fh.close()
local slots = {1,2,3, 5,6,7, 9,10,11}

newRecipe = {
		qty = 0,
		type = "craft",
		name = "N/A",
		r = {
			
		}
	}

for k, slot in pairs(slots) do
  item = turtle.getItemDetail(slot)
  if item ~= nil then
    newRecipe.r[k] = item.name .. "," .. tostring(item.damage)
  else
    newRecipe.r[k] = 0
  end
end
if turtle.getItemDetail() == nil then
  turtle.craft()
end

result = turtle.getItemDetail()

newRecipe.qty = result.count
print("Enter result name:")
newRecipe.name = read()
db[result.name .. "," .. tostring(result.damage)] = newRecipe 

local fh = fs.open("crafting.luadb","w")
fh.write(textutils.serialize(db))
fh.close()
