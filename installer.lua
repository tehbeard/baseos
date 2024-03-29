print("Loading BaseOS installer")
local baseRepo = "https://www.tehbeard.com/baseos/"

function get(url)
	print("URL " .. url)
    local resp = http.get(url)
    local s = resp.readAll()
    resp.close()
    return s
end

function repoGet(file)
	print("opening " .. baseRepo .. file)
  return get(baseRepo .. file)
end

function repoInstallFile(file)
  -- Make Dir if nessecary
  print("Downloading " .. file)
  local pLength = 1 + #fs.getName(file)
  if(pLength < #file) then
      local path = string.sub(file,1,#file - pLength)
      fs.makeDir(path)
  end
  --Download the file
  local fh = fs.open(file,"w")
  fh.write(repoGet(file))
  fh.close()
end

function repoInstall(entry)
	term.clear()
	term.setCursorPos(1,1)
	if fs.exists(entry.files[1]) then
		print(entry.name .. " already installed.")
		return
	end
	print("Installing " .. entry.name)
	for _,file in pairs(entry.files) do
		repoInstallFile(file)
	end
	-- TODO run installer script here?
	if entry.deps ~= nil then
		print("Installing dependencies")
		for _,dep in pairs(entry.deps) do
			print("Checking dependency " .. dep)
			print(textutils.serialize(index[dep]))
			repoInstall(index[dep])
		end
	end

end

function chkInstallStatus(entry)
	return function()
	  if fs.exists(entry.files[1]) then
	  	return "Installed"
	  else
	  	return "Install"
	  end
	end
end

print("Downloading new index")
index = textutils.unserialize(repoGet("repo/index"))
repoInstall(index["txtmenu"])
txtMenu = require("bin/api/txtMenu");
txtMenu.setTitle("BaseOS Installer")
for id,entry in pairs(index) do
	if not entry.api then
        txtMenu.addMenuItem(entry.name,chkInstallStatus(entry),function() repoInstall(entry) sleep(2) end)
    end
end

for id,entry in pairs(index) do
	if entry.api then
        txtMenu.addMenuItem(entry.name,chkInstallStatus(entry),function() repoInstall(entry) sleep(2) end)
    end
end

txtMenu.addMenuItem("Exit","",txtMenu.stopMainLoop)
term.clear()
txtMenu.mainLoop()
term.clear()
term.setCursorPos(1,1)
print("Exiting BaseOS Installer.")