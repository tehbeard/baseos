local ft = {}
function ft.forward(count)
  c = count
  if c == nil then c = 1 end
  for i=1,c,1 do
    while not turtle.forward() do turtle.dig() end
  end
end

function ft.up(count)
  c = count
  if c == nil then c = 1 end
  for i=1,c,1 do
    while not turtle.up() do turtle.digUp() end
  end
end

function ft.down(count)
  c = count
  if c == nil then c = 1 end
  for i=1,c,1 do
    while not turtle.down() do turtle.digDown() end
  end
end

return ft