local stars = {}

-- table
local starList = {}

function stars.load()
end

function stars.add()
    table.insert(starList, {
        x = 800 + love.math.random(20, 100),
        y = love.math.random(0, 600),
        size = love.math.random(5, 15)
    })
end

function stars.update(dt, speed) 
    for i = #starList, 1, -1 do  
        starList[i].x = starList[i].x - speed * dt -- move star to left
        if starList[i].x < -20 then -- remove star if it goes off screen
            table.remove(starList, i)
        end
    end
end

function stars.draw() -- daw stars
    love.graphics.setColor(1, 1, 1)
    for _, star in ipairs(starList) do 
        love.graphics.circle("fill", star.x, star.y, star.size) 
    end
end

function stars.reset()
    starList = {}
end

function stars.getList()
    return starList
end

return stars 