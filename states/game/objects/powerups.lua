
-- table
local powerups = {}

local powerupsList = {}
local shieldImage = nil

function powerups.load()
    shieldImage = love.graphics.newImage("assets/images/shield.png")
end

function powerups.add(x, y, fromAsteroid)
    if not fromAsteroid then return end
    
    table.insert(powerupsList, {
        x = x,
        y = y,
        type = love.math.random(2) == 1 and "shield" or "speed",
        size = 15,
        speed = love.math.random(1, 3),
        w = 30,
        h = 30
    })
end

function powerups.update(dt, gameSpeed) -- update powerups position
    for i = #powerupsList, 1, -1 do
        local p = powerupsList[i]
        p.x = p.x - gameSpeed * dt
        p.y = p.y + math.sin(love.timer.getTime() * p.speed) * 0.5 -- floating effect
        
        if p.x < -20 then --remove power up if it goes off screen
            table.remove(powerupsList, i)
        end
    end
end

function powerups.draw() 
    for _, p in ipairs(powerupsList) do 
        if p.type == "shield" then --shield power up hover effect
            love.graphics.setColor(0.2, 0.6, 1, 0.5) 
            love.graphics.circle("fill", p.x, p.y, p.size + 5)
            
            love.graphics.setColor(1, 1, 1) --shield icon
            love.graphics.draw(shieldImage, p.x, p.y, 0, 0.1, 0.1, 
                shieldImage:getWidth()/2, shieldImage:getHeight()/2)
        else
            love.graphics.setColor(1, 0.5, 0, 0.5) --speed up effect
            love.graphics.circle("fill", p.x, p.y, p.size + 5)
            
            love.graphics.setColor(1, 0.5, 0) --speed icon
            love.graphics.circle("fill", p.x, p.y, p.size)
        end
    end
end

function powerups.reset()
    powerupsList = {}
end

function powerups.getList()
    return powerupsList
end

return powerups