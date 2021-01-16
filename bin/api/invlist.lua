_DIR = "up"

local p = peripheral.wrap("bottom")


local invlist = {}

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={} ; i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

function findSlot(id)
  t = p.size()
  a = 1
  while a < t+1 do
    s = p.getItemDetail(a)
    if s ~= nil then
      if (
           s.name == id 
         ) or 
         ( 
           s.tags ~= nil and 
           s.tags[id] 
         ) then
        return a
      end
    end
    a = a + 1  
  end
  return nil
end

function invlist.countItem(id)
  t = p.size()
  a = 1
  count = 0
  while a < t+1 do
    s = p.getItemDetail(a)
    if s ~= nil then
      if (s.name == id ) or ( s.tags ~= nil and s.tags[id] ) then
        count = count + s.count
      end
    end
    a = a + 1  
  end
  return count
end

function invlist.list()
  r = {}
  t = p.size()
  a = 1
  while a < t+1 do
    s = p.getItemDetail(a)
    if s ~= nil then
      local tag = s.name
      if r[tag] == nil then
        r[tag] = {
          name = s.displayName,
          count = 0
        }
      end
        r[tag].count = r[tag].count + s.count
    end
    a = a + 1  
  end
  return r
end


function invlist.fetchItem(item, to, count)
  if count == nil then
    count = 1
  end
  slot = findSlot(item)
  if slot ~= nil then
    print("Found in slot " .. tostring(slot))
    found = p.pushItems("top", slot, count) > 0
    turtle.select(to)
    turtle.suckUp(count)
    return found
  else
    return false
  end
end

function invlist.clean()
  for i = 1,16 do
    if(turtle.getItemCount(i) > 0) then
      turtle.select(i)
      turtle.dropDown()
    end
  end
end

return invlist;