local gameover = {}

local game = require("states.game.state")

local stars = {}
local titleFont
local scoreFont
local button = {
    x = 300,
    y = 400,
    w = 200,
    h = 50,
    text = "RESTART",
    hover = false
}

function gameover.load()
    -- load fonts with fallback
    local success, err = pcall(function()
        titleFont = love.graphics.newFont("assets/fonts/american_captain.ttf", 64)
        scoreFont = love.graphics.newFont("assets/fonts/wasted_vindey.ttf", 48)
    end)
    
    if not success then
        print("Could not load custom fonts, using defaults:", err)
        titleFont = love.graphics.newFont(64)
        scoreFont = love.graphics.newFont(48)
    end
    
    -- initialize stars
    for i = 1, 100 do
        stars[i] = {
            x = love.math.random(0, 800),
            y = love.math.random(0, 600),
            size = love.math.random(1, 3),
            speed = love.math.random(50, 150)
        }
    end
end

function gameover.enter()
    -- reset button state
    button.hover = false
end

function gameover.update(dt)
    -- update the stars x and y positions
    for _, star in ipairs(stars) do
        star.x = star.x - star.speed * dt
        if star.x < 0 then
            star.x = 800
            star.y = love.math.random(0, 600)
        end
    end
    
    -- check mouse hover over restart button
    local mouseX, mouseY = love.mouse.getPosition()
    button.hover = mouseX >= button.x and
                  mouseX <= button.x + button.w and
                  mouseY >= button.y and
                  mouseY <= button.y + button.h
end

function gameover.draw()
    -- draw space background
    love.graphics.setBackgroundColor(0.05, 0.05, 0.1)
    
    -- draw stars
    love.graphics.setColor(1, 1, 1)
    for _, star in ipairs(stars) do
        love.graphics.circle("fill", star.x, star.y, star.size)
    end
    
    -- draw game over text
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 0, 0)
    local text = "GAME OVER"
    local textWidth = titleFont:getWidth(text)
    love.graphics.print(text, 400 - textWidth/2, 200)
    
    -- draw final score
    love.graphics.setFont(scoreFont)
    love.graphics.setColor(1, 1, 1)
    local scoreText = "FINAL SCORE: " .. game.getScore()
    local scoreWidth = scoreFont:getWidth(scoreText)
    love.graphics.print(scoreText, 400 - scoreWidth/2, 300)
    
    -- draw restart button
    love.graphics.setColor(button.hover and {0.8, 0.8, 0.8} or {1, 1, 1})
    love.graphics.rectangle("line", button.x, button.y, button.w, button.h)
    love.graphics.setFont(scoreFont)
    local buttonTextWidth = scoreFont:getWidth(button.text)
    love.graphics.print(button.text, button.x + button.w/2 - buttonTextWidth/2, button.y + 5)
end

function gameover.mousepressed(x, y, mouseButton)
    if mouseButton == 1 and
       x > button.x and x < button.x + button.w and
       y > button.y and y < button.y + button.h then
        return "game"
    end
end

function gameover.keypressed(key)
    if key == "return" or key == "space" then
        return "game"
    end
end

return gameover 