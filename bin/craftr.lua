local invlist = require("/api/invlist");
local txtMenu = require("/api/txtMenu");

term.clear()
term.setCursorPos(1,1)
print("Loading fabrication templates")
local fh = fs.open("/etc/crafting.luadb","r")
local db = textutils.unserialize(fh.readAll())
local c = 0
for k,v in pairs(db) do
	c = c + 1
end
print("Fabrication templates loaded...")
print(tostring(c) .. " found")
sleep(1)
fh.close()
_SLOTS = { 1,2,3,5,6,7,9,10,11 }

function craft(r)
	invlist.clean()
	for idx, ing in ipairs(r) do
		if(ing ~= 0) then
			print("Getting " .. ing)
			if not invlist.fetchItem(ing, _SLOTS[idx]) then
				print("Could not find " .. tostring(ing) .. " to " .. tostring(_SLOTS[idx]))
				invlist.clean()
				return false
			else
				print("FOUND!")
			end
		else
			print("Found 0")
		end
	end
	if not turtle.craft() then
		invlist.clean()
		return false
	end
	invlist.clean()
	return true
end

craftingStack = {}
function pop()
  	return table.remove(craftingStack,#craftingStack)
end
function push(item)
  	return table.insert(craftingStack,item)
end
function peek()
  	return craftingStack[#craftingStack]
end



function executeCraftingTask(item, qty)
	--Prep crafting queue
	for i = 1,math.ceil(qty / item.qty),1 do
		push(item)
	end
	-- Loop the queue
	while #craftingStack > 0 do
		cur = peek()
		ttl = {}
		for _,item in pairs(cur.r) do
			if item ~= 0 then
				ttl[item] = (ttl[item] or 0) + 1 
			end
		end
		local canContinue = true
		for item,qty in pairs(ttl) do
			if qty > invlist.countItem(item) then
				print("insufficient " .. item .. ", adding to stack to craft")
				local qtyNeeded = qty - invlist.countItem(item)
				if db[item] == nil then
					print("CANNOT FABRICATE " .. item .. ", INSERT " .. tostring(qtyNeeded) .. " TO RESOLVE")
					exit()
				end
				for i = 1, math.ceil(qtyNeeded / db[item].qty), 1 do
					push(db[item])
				end
				canContinue = false 
			end
		end
		if canContinue then
			--Craft here
			if craft(cur.r) then
				pop()
			else
				print("ERROR")
				exit()
			end
		end
	end
end

function doCraft(e)
	txtMenu.stopMainLoop()
	if not invlist.fetchItem(e.data.key, 16, 1) then
		executeCraftingTask(db[e.data.key],1)
	end
	invlist.fetchItem(e.data.key, 16, math.max(1, db[e.data.key].qty))
	txtMenu.mainLoop()
end

txtMenu.setTitle("CCCraft v1.1 beta")
--TODO: INTERFACE
for key, item in pairs(db) do
	txtMenu.addMenuItem(item.name,tostring(item.qty), doCraft,{ key = key})
end
txtMenu.addMenuItem("Exit","", function() 
txtMenu.stopMainLoop()
term.clear()
end)
txtMenu.mainLoop()