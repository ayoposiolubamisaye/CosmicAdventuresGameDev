local lasers = {}

-- table 
local laserList = {}

function lasers.load()
end

function lasers.shoot(ship)
    table.insert(laserList, { -- shooting effect
        x = ship.x + ship.w,
        y = ship.y + ship.h/2 - 5,
        w = 30,
        h = 10
    })
end

function lasers.update(dt)
    for i = #laserList, 1, -1 do --update the lasers position
        laserList[i].x = laserList[i].x + 800 * dt
        if laserList[i].x > 800 then
            table.remove(laserList, i)
        end
    end
end

function lasers.draw()
    love.graphics.setColor(0, 1, 1, 1) -- laser color
    for _, laser in ipairs(laserList) do
        love.graphics.rectangle("fill", laser.x, laser.y, laser.w, laser.h)
        love.graphics.setColor(0, 1, 1, 0.3)
        love.graphics.rectangle("fill", laser.x - 5, laser.y - 5, laser.w + 10, laser.h + 10)
    end
end

function lasers.reset()
    laserList = {}
end

function lasers.getList()
    return laserList
end

return lasers 