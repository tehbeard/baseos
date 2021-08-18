function load(filename, def)
    if fs.exists("/etc/" .. filename) then
      fh = fs.open(filename,"r")
      tbl = textutils.unserialize(fh.readAll())
      fh.close()
      return tbl
    end
  
    tbl = {}
    print("First time run, please fill out the config.")
    for key,query in pairs(def) do
        term.clear()
        term.setCursorPos(1,1)
        
        local r = nil
        -- If Query is a string, just display that, else run a function for more interactive settings
        if type(query) == "string" then
          print(query)
          term.write(key .. "=")
          r = read()
        elseif type(query) == "function" then 
          r = query(tbl)
        end
      
        
        if #r == 0 then r = nil end
        tbl[key] = r
    end
    fh = fs.open(filename,"w")
    fh.write(textutils.serialize(tbl))
    fh.close()
    return tbl
  end

return load