-- table
local ship = {}

ship.x = 50
ship.y = 300
ship.w = 40
ship.h = 40
ship.speed = 300
ship.fuel = 100
ship.maxFuel = 100
ship.shield = false
ship.boost = false
ship.boostTimer = 0
ship.boostSpeed = 600  -- double speed when boosting
ship.img = nil
ship.scale = 0.2

function ship.load()
    local ok, img = pcall(love.graphics.newImage, "assets/images/spaceship.png")
        ship.img = img
        ship.w = img:getWidth() * ship.scale
        ship.h = img:getHeight() * ship.scale
end

function ship.update(dt)
    -- handle boost timer
    if ship.boost then
        ship.boostTimer = ship.boostTimer - dt
        if ship.boostTimer <= 0 then
            ship.boost = false
        end
    end
    
    -- move ship
    local currentSpeed = ship.boost and ship.boostSpeed or ship.speed
    if love.keyboard.isDown("up") then
        ship.y = math.max(0, ship.y - currentSpeed * dt)
        ship.fuel = math.max(0, ship.fuel - 20 * dt)
    end
    if love.keyboard.isDown("down") then
        ship.y = math.min(600 - ship.h, ship.y + currentSpeed * dt)
        ship.fuel = math.max(0, ship.fuel - 20 * dt)
    end
end

function ship.draw()
    if ship.img then 
        if ship.shield then
            love.graphics.setColor(0.2, 0.6, 1)
        else
            love.graphics.setColor(1, 1, 1)
        end
        love.graphics.draw(ship.img, ship.x, ship.y, 0, ship.scale, ship.scale)
    end
    
    -- draw shield if active
    if ship.shield then
        love.graphics.setColor(0.2, 0.6, 1, 0.5)
        love.graphics.circle("fill", ship.x + ship.w/2, ship.y + ship.h/2, 30)
    end
end

function ship.reset()
    ship.x = 50
    ship.y = 300
    ship.fuel = 100
    ship.shield = false
    ship.boost = false
    ship.boostTimer = 0
end

return ship