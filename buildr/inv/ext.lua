local ext = {}
ext.desc = "Call external program"
ext.restock = function(slot)
    shell.run(args[2], slot)
end

return ext