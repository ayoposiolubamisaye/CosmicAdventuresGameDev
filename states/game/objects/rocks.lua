--table

local rocks = {}
local explosion = love.audio.newSource("sounds/Retro_Explosion_Short_15.wav", "static")

local rockList = {}
local asteroidImage = nil
local brokenAsteroidImage = nil

function rocks.load()
    local ok, img = pcall(love.graphics.newImage, "assets/images/astroid.png")
        asteroidImage = img
    local ok, img = pcall(love.graphics.newImage, "assets/images/broken-astroid.png")
        brokenAsteroidImage = img
end

function rocks.add()
    local baseSize = 0.05
    local isBreakable = love.math.random() < 0.3 -- 30% chance for breakable rocks
    
    local sizeVariation = love.math.random(0.8, 1.2)
    local finalSize = baseSize * sizeVariation
    
    local spawnX = 800 + love.math.random(20, 150)
    local spawnY = love.math.random(0, 600)
    
    local startRotation = love.math.random() * 6
    local rotationSpeed = love.math.random(-2, 2)
    
    table.insert(rockList, {
        x = spawnX,
        y = spawnY,
        scale = finalSize,
        breakable = isBreakable,
        hits = isBreakable and 3 or 1,
        rotation = startRotation,
        rotationSpeed = rotationSpeed,
        w = 40,
        h = 40
    })
end

function rocks.update(dt, baseSpeed, score)
    for i = #rockList, 1, -1 do
        local rock = rockList[i]
        
        -- move rock left
        local scaledSpeed = baseSpeed + (score or 0) * 0.15
        rock.x = rock.x - scaledSpeed * dt
        
        -- rotate rock
        rock.rotation = rock.rotation + rock.rotationSpeed * dt
        
        -- remove if off screen
        if rock.x < -50 then
            table.remove(rockList, i)
        end
    end
end

function rocks.draw()
    for _, rock in ipairs(rockList) do
        if rock.breakable then
            love.graphics.setColor(1, 0.5, 0.5) -- red tint for breakable
        else
            love.graphics.setColor(1, 1, 1) -- white for regular
        end
        
        local img = rock.breakable and rock.hits == 1 and brokenAsteroidImage or asteroidImage
        
        local imageScale = rock.scale * (asteroidImage:getWidth() / img:getWidth())
        
        love.graphics.draw(img, rock.x, rock.y, rock.rotation, imageScale, imageScale, img:getWidth()/2, img:getHeight()/2)
        
        if rock.breakable then
            love.graphics.setColor(1, 0, 0) -- red color for hit points
            local hitPointSpacing = 10 -- space between hit points
            local startX = rock.x - 15 -- starting x position
            local hitPointY = rock.y - 30 -- y position for all hit points
            
            for hitPoint = 1, rock.hits do
                local hitPointX = startX + (hitPoint - 1) * hitPointSpacing
                love.graphics.circle("fill", hitPointX, hitPointY, 3)
            end
        end
    end
end

function rocks.reset()
    rockList = {}
end

function rocks.getList()
    return rockList
end

return rocks