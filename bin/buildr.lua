local ft = require("/api/ft")
local txtMenu = require("/api/txtMenu")

local args = {...}
local programs = {}

local placers = {}


local function even(num)
	return num % 2 == 0
end

local function odd(num)
	return not even(num)
end

function execRoutine(prog)
	term.clear()
	args = {}
	for i=2,#prog,1 do
		print(prog[i])
		table.insert(args,tonumber(read()))
	end
	prog[1](unpack(args))
end

txtMenu.setTitle("Buildr V1.0")

selected = nil
for k,v in pairs(programs) do
    txtMenu.addMenuItem(k,"Build",function() selected = v txtMenu.stopMainLoop() end)
end

txtMenu.addMenuItem("Exit",nil,function() txtMenu.stopMainLoop() end)


local run = true
while run do
    txtMenu.mainLoop()
    if selected ~= nil then
    	term.clear()
    	term.setCursorPos(1,1)
    	execRoutine(selected)
    	selected = nil
    else
    	run = false
    end
end