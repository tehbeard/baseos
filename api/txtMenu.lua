local entries = {}
local selected = 1
local page = 1
local perPage = 10
local title = "";

local txtMenu = {}

function txtMenu.addMenuItem(name,status,callback,d)
	local _d = d
	if _d == nil then _d = {} end
	table.insert(entries,{
		name=name,
		status=status,
		onclick=callback,
		data=_d
		})
end

function txtMenu.setTitle(t)
	title = t
end

function txtMenu.setEntries(e)
	entries = e
end

function txtMenu.setPage(p)
	page = p
end

function txtMenu.prevPage()
	selected = 1
	page = math.max(1,page - 1)
end

function txtMenu.nextPage()
	selected = 1
	page = math.min(math.ceil(#entries / perPage),page + 1)
end

function txtMenu.prevSel()
	selected = math.max(1,selected - 1)
end

function txtMenu.nextSel()
	actualIdx = txtMenu.getSelectedIdx() + 1
    if(actualIdx <= #entries) then
	    selected = math.min(perPage,selected + 1)
	end
end

function txtMenu.getSelectedIdx()
	return (perPage * (page-1))+selected
end


function keyListen()
	_,param = os.pullEvent("key")
	key = keys.getName(param)
	if key == "up" then
		txtMenu.prevSel()
	elseif key == "down" then
		txtMenu.nextSel()
	end

	if key == "left" then
		txtMenu.prevPage()
	elseif key == "right" then
		txtMenu.nextPage()
	end

	if key == "enter" then
		e = entries[txtMenu.getSelectedIdx()]
		e.onclick(e)
		sleep(0.5)
	end

end

function scrollListen()
	_,d = os.pullEvent("mouse_scroll")
	if d == -1 then
		txtMenu.prevSel()
	else
		txtMenu.nextSel()
	end
end

function clickListen()
	_,button,x,y = os.pullEvent("mouse_click")
	if button == 1 then
		w,h = term.getSize()
		rightSide = x > (w/2)
		if y > 1 and y < h then
			idx = y - 1
			if selected == idx and rightSide then
			    e = entries[txtMenu.getSelectedIdx()]
		        e.onclick(e)
		        sleep(0.5)
		    else
		    	selected = idx
		    end
		end
		if y == h then
			if rightSide then txtMenu.nextPage() else txtMenu.prevPage() end
		end
	end
end

function mon_rez()
	os.pullEvent("monitor_resize")
	term.clear()
	term.setCursorPos(1,1)
	selected = 1
	page = 1
end

function sleep_update()
	    os.sleep(1)
end

function repaint()
	-- Get height
	local w,h = term.getSize()
	perPage = h-2
	term.setCursorPos(1,1)
	term.clearLine()
	term.write(" -= " .. title .. " =- Page: " .. tostring(page) .. " of " .. tostring(math.ceil(#entries/perPage)))

	for i=1,perPage,1 do
		term.setCursorPos(1,1+i)
		term.clearLine()
		local entry = entries[((page-1)*perPage) + i]
		if entry ~= nil then
		    -- Generate left hand side, number and string
  		    local line = string.format("%02d",((page-1)*perPage) + i)
  		    if selected == i then
    		  	line = "[" .. line .. "] "
    		  	if term.isColor() then term.setBackgroundColor(colors.green) end
	        else
			    line = " " .. line .. "  "
			    if term.isColor() then term.setBackgroundColor(colors.black) end
		    end
		    line = line .. entry.name
		    
		    term.write(line)
		    -- Now do right hand side
		    if entry.status ~= nil then
			    if type(entry.status) == "string" then
    				statLine = "[" .. entry.status .. "]"
	    		elseif type(entry.status) == "function" then 
		    		statLine = "[" .. entry.status(entry) .. "]"
			    end
			    term.setCursorPos(w - #statLine+1,1+i)
			    term.write(statLine)
		    end
		    if term.isColor() then term.setBackgroundColor(colors.black) end
		end
	end
	term.setCursorPos(1,h)
	term.write("[PREV]")
	term.setCursorPos(w-5,h)
	term.write("[NEXT]")
end

local running = false

function txtMenu.mainLoop(update)
	running = true
	while running do
		repaint()
        parallel.waitForAny(scrollListen,keyListen,clickListen,mon_rez)
    end
end

function txtMenu.stopMainLoop()
	running = false
end


return txtMenu