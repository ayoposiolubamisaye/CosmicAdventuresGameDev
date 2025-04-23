local game = {}

local backgroundMusic = love.audio.newSource("sounds/synthwave-retro-80s-321106.mp3", "static")

local ship = require("states.game.objects.ship")
local stars = require("states.game.objects.stars")
local rocks = require("states.game.objects.rocks")
local powerups = require("states.game.objects.powerups")
local lasers = require("states.game.objects.lasers")
local collision = require("states.game.utils.collision")
local getParticleImage = require("assets.particle")

local SCREEN_WIDTH = 800
local SCREEN_HEIGHT = 600
local GAME_SPEED = 200
local STAR_SPEED = 1.5
local ASTEROID_CHANCE = 0.4
local LASER_DELAY = 0.2
local STAR_SPAWN_DELAY = 1
local ROCK_SPAWN_DELAY = 2

-- Game state
game.score = 0
local speed = GAME_SPEED
local spawnTime = 0
local shootTime = 0
local titleFont = love.graphics.newFont(48)
local scoreFont = love.graphics.newFont(32)
local particles

function game.load()
    -- load game objects
    ship.load()
    stars.load()
    rocks.load()
    powerups.load()
    lasers.load()
    backgroundMusic:play()
    
    -- setup particles
    local success, particleImage = pcall(getParticleImage)
    if success and particleImage then
        particles = love.graphics.newParticleSystem(particleImage, 1000)
        particles:setParticleLifetime(1, 2)
        particles:setEmissionRate(50)
        particles:setSizeVariation(0.5)
        particles:setLinearAcceleration(-20, -20, 20, 20)
        particles:setColors(1, 1, 0, 1, 1, 0.5, 0, 1)
    end
    
    -- custom fonts
    local success, err = pcall(function()
        titleFont = love.graphics.newFont("assets/fonts/american_captain.ttf", 48)
        scoreFont = love.graphics.newFont("assets/fonts/wasted_vindey.ttf", 32)
    end)
    
end

function game.update(dt)
    -- Update timers
    spawnTime = spawnTime + dt
    shootTime = shootTime + dt
    
    ship.update(dt) -- check fuel
    if ship.fuel <= 0 then
        return "gameover"
    end
    
    -- spawn new objects
    if spawnTime >= STAR_SPAWN_DELAY then
        stars.add()
        if love.math.random() < ASTEROID_CHANCE then
            rocks.add()
        end
        spawnTime = 0
    end
    
    -- update all game objects
    stars.update(dt, speed)
    rocks.update(dt, speed)
    lasers.update(dt)
    powerups.update(dt, speed)
    
    -- update particles
    if particles then
        particles:update(dt)
    end
    
    -- check collisions
    local gameOver, newScore = collision.checkAll(ship, stars, rocks, lasers, powerups, game.score)
    game.score = newScore or game.score
    if gameOver then
        return "gameover"
    end
end

function game.keypressed(key)
    if key == "space" and shootTime >= LASER_DELAY then
        lasers.shoot(ship)
        shootTime = 0
    end
end

function game.enter()
    -- reset game variables
    game.score = 0
    speed = GAME_SPEED
    spawnTime = 0
    shootTime = 0
    
    -- reset all game objects
    ship.reset()
    stars.reset()
    rocks.reset()
    powerups.reset()
    lasers.reset()
end


function game.draw()
    -- draw background
    love.graphics.setBackgroundColor(0.05, 0.05, 0.1)
    
    -- Draw game objects
    stars.draw()
    rocks.draw()
    lasers.draw()
    powerups.draw()
    ship.draw()
    
    -- draw particles
    if particles then
        love.graphics.draw(particles, ship.x + ship.w, ship.y + ship.h/2)
    end
    
    -- draw HUD
    drawHUD()
end

function drawFuelBar(ship)
    local fuelColor = ship.fuel > 50 and {0, 1, 0} or ship.fuel > 20 and {1, 1, 0} or {1, 0, 0}
    love.graphics.setColor(fuelColor)
    love.graphics.rectangle("fill", 91, 24, ship.fuel * 144 / 100, 22)
    love.graphics.setColor(1,1,1)
    love.graphics.rectangle("line", 90, 24, 146, 22, 4)
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.printf(math.floor(ship.fuel) .. "/100 FUEL", 90, 24, 144, "center")
end

function drawHUD()
    -- fuel bar
    drawFuelBar(ship)

    love.graphics.setFont(scoreFont)
    love.graphics.setColor(1, 1, 1)
    local scoreText = "SCORE: " .. game.score
    local textWidth = scoreFont:getWidth(scoreText)
    love.graphics.print(scoreText, 330, 24)
    
    -- powerup status
    if ship.shield then
        love.graphics.setColor(0.2, 0.6, 1)
        love.graphics.print("SHIELD ACTIVE", 20, 80)
    end
    if ship.boost then
        love.graphics.setColor(1, 0.5, 0)
        love.graphics.print("SPEED BOOST: " .. string.format("%.1f", ship.boostTimer), 20, 110)
    end
end

-- current score
function game.getScore()
    return game.score
end

return game 