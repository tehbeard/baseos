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

function findSlot(item)
  id,dmg = unpack(split(item,","))
  t = p.getInventorySize()
  a = 1
  while a < t+1 do
    s = p.getStackInSlot(a)
    if s ~= nil then
      if (
           s.id == id and 
           ( 
             (
               dmg ~= nil and 
               s.dmg == tonumber(dmg) 
             ) or 
             dmg == nil
           ) 
         ) or 
         ( 
           s.ore_dict ~= nil and 
           s.ore_dict[id] 
           and dmg == nil 
         ) then
        return a
      end
    end
    a = a + 1  
  end
  return nil
end

function invlist.countItem(item)
  id,dmg = unpack(split(item,","))
  t = p.getInventorySize()
  a = 1
  qty = 0
  while a < t+1 do
    s = p.getStackInSlot(a)
    if s ~= nil then
      if (s.id == id and ( (dmg ~= nil and s.dmg == tonumber(dmg) ) or dmg == nil) ) or ( s.ore_dict ~= nil and s.ore_dict[id] and dmg == nil ) then
        qty = qty + s.qty
      end
    end
    a = a + 1  
  end
  return qty
end

function invlist.list()
  r = {}
  t = p.getInventorySize()
  a = 1
  while a < t+1 do
    s = p.getStackInSlot(a)
    if s ~= nil then
      local tag = s.id .. "," .. tostring(s.dmg)
      if r[tag] == nil then
        r[tag] = {
          name = s.display_name,
          qty = 0
        }
      end
        r[tag].qty = r[tag].qty + s.qty
    end
    a = a + 1  
  end
  return r
end


function invlist.fetchItem(item, to, qty)
  if qty == nil then
    qty = 1
  end
  slot = findSlot(item)
  if slot ~= nil then
    print("Found in slot " .. tostring(slot))
    return p.pushItemIntoSlot(_DIR, slot, qty, to) > 0
  else
    return false
  end
end

function invlist.clean()
  for i = 1,16 do
    turtle.select(i)
    turtle.dropDown()
  end
end

return invlist;