local collision = {}
local explosion = love.audio.newSource("sounds/Retro_Explosion_Short_15.wav", "static")

function collision.checkAll(ship, stars, rocks, lasers, powerups, score)
    -- check star collisions
    for i = #stars.getList(), 1, -1 do
        local star = stars.getList()[i]
        if collision.check(ship, star) then
            ship.fuel = math.min(ship.maxFuel, ship.fuel + 10)
            table.remove(stars.getList(), i)
        end
    end
    
    -- check rock collisions
    for i = #rocks.getList(), 1, -1 do
        local rock = rocks.getList()[i]
        if collision.check(ship, rock) then
            if ship.shield then
                ship.shield = false
            else
                return true -- game over
            end
            table.remove(rocks.getList(), i)
        end
    end
    
    -- Check laser collisions
    for i = #lasers.getList(), 1, -1 do
        local laser = lasers.getList()[i]
        for j = #rocks.getList(), 1, -1 do
            local rock = rocks.getList()[j]
            if collision.checkLaser(laser, rock) then -- check if the laser hit the rock sprite
                if rock.breakable then
                    rock.hits = rock.hits - 1
                    if rock.hits <= 0 then -- if rock has no hits, spawn power up
                        powerups.add(rock.x, rock.y, true)
                        table.remove(rocks.getList(), j)
                        explosion:play()
                        score = score + 50  -- 50 points for destroying
                    else
                        score = score + 10  -- 10 points for hitting 
                    end
                else
                    table.remove(rocks.getList(), j)
                    explosion:play()
                    score = score + 20  -- 20 points for destroying reg rock
                end
                table.remove(lasers.getList(), i)
                break
            end
        end
    end
    
    -- check powerup collisions
    for i = #powerups.getList(), 1, -1 do
        local powerup = powerups.getList()[i]
        if collision.check(ship, powerup) then
            if powerup.type == "shield" then
                ship.shield = true
            elseif powerup.type == "speed" then
                ship.boost = true
                ship.boostTimer = 5
            end
            table.remove(powerups.getList(), i)
        end
    end
    
    return false, score
end

function collision.check(obj1, obj2)
    if obj2.scale then
        -- use image-based collision for asteroids with a larger buffer
        local asteroidSize = 40 * obj2.scale
        local halfSize = asteroidSize / 2
        local buffer = 10  -- added buffer zone
        return obj1.x < obj2.x + halfSize + buffer and
               obj1.x + obj1.w > obj2.x - halfSize - buffer and
               obj1.y < obj2.y + halfSize + buffer and
               obj1.y + obj1.h > obj2.y - halfSize - buffer
    else
        -- fallback to circle collision with buffer
        local size = obj2.size or 20
        local buffer = 10
        return obj1.x < obj2.x + size + buffer and
               obj1.x + obj1.w > obj2.x - buffer and
               obj1.y < obj2.y + size + buffer and
               obj1.y + obj1.h > obj2.y - buffer
    end
end

function collision.checkLaser(laser, rock)
    if rock.scale then
        local asteroidSize = 40 * rock.scale
        local halfSize = asteroidSize / 2
        local buffer = 15  -- larger buffer for lasers
        -- check collision with the full asteroid rectangle plus buffer
        return laser.x < rock.x + halfSize + buffer and
               laser.x + laser.w > rock.x - halfSize - buffer and
               laser.y < rock.y + halfSize + buffer and
               laser.y + laser.h > rock.y - halfSize - buffer
    else
        local size = rock.size or 20
        local buffer = 15
        return laser.x < rock.x + size + buffer and
               laser.x + laser.w > rock.x - buffer and
               laser.y < rock.y + size + buffer and
               laser.y + laser.h > rock.y - buffer
    end
end

return collision