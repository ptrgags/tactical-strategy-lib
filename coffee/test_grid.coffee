grid = new Grid 20, 20

for i in [1..5]
    grid.put 2, i, i

document.write "<h3>Testing Grid</h3>"
document.write "#{grid.get(2, 3)}<br/>"
document.write "#{grid.remove(2, 4)}<br/>"
document.write "#{grid.repr()}<br/>"