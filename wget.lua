local tArgs = {...}
local url = tArgs[1]
local sFile = tArgs[2]
if url == nil or sFile == nil then
print("wget url file") return end
local sPath = shell.resolve(sFile)
if fs.exists(sPath) or fs.isDir(sPath) then
  print("File exists already")
end

function get(url)
    local resp = http.get(url)
    local s = resp.readAll()
    resp.close()
    return s
end


if resp then
  print("Downloaded..")
  local file = fs.open(sPath,"w")
  file.write(get(url))
  resp.close()
  file.close()
else
  print("Failed to download")
end