local menu = {}
local game = require("states.game.state")

-- Menu state variables
local stars = {}
local titleFont
local buttonFont
local startButton = {
    x = 300,
    y = 300,
    w = 200,
    h = 50,
    text = "START GAME",
    hover = false
}

function menu.load()
    -- Load fonts with fallback
    local success, err = pcall(function()
        titleFont = love.graphics.newFont("assets/fonts/american_captain.ttf", 72)
        buttonFont = love.graphics.newFont("assets/fonts/wasted_vindey.ttf", 32)
    end)
    
    if not success then
        print("Could not load custom fonts, using defaults:", err)
        titleFont = love.graphics.newFont(72)
        buttonFont = love.graphics.newFont(32)
    end
    
    -- Initialize stars
    for i = 1, 100 do
        stars[i] = {
            x = love.math.random(0, 800),
            y = love.math.random(0, 600),
            size = love.math.random(1, 3),
            speed = love.math.random(50, 150)
        }
    end
end

function menu.enter()
    -- Reset button state
    startButton.hover = false
end

function menu.update(dt)
    -- Update stars
    for _, star in ipairs(stars) do
        star.y = star.y + star.speed * dt
        if star.y > 600 then
            star.y = 0
            star.x = love.math.random(0, 800)
        end
    end
    
    -- Check button hover
    local mx, my = love.mouse.getPosition()
    startButton.hover = mx > startButton.x and mx < startButton.x + startButton.w and
                       my > startButton.y and my < startButton.y + startButton.h
end

function menu.draw()
    -- Draw space background
    love.graphics.setBackgroundColor(0.05, 0.05, 0.1)
    
    -- Draw stars
    love.graphics.setColor(1, 1, 1)
    for _, star in ipairs(stars) do
        love.graphics.circle("fill", star.x, star.y, star.size)
    end
    
    -- Draw title
    love.graphics.setFont(titleFont)
    love.graphics.setColor(1, 1, 1)
    local title = "COMIC ADVENTURES"
    local titleWidth = titleFont:getWidth(title)
    love.graphics.print(title, 400 - titleWidth/2, 150)
    
    -- Draw start button
    love.graphics.setColor(startButton.hover and {0.8, 0.8, 0.8} or {1, 1, 1})
    love.graphics.rectangle("line", startButton.x, startButton.y, startButton.w, startButton.h)
    love.graphics.setFont(buttonFont)
    local buttonTextWidth = buttonFont:getWidth(startButton.text)
    love.graphics.print(startButton.text, startButton.x + startButton.w/2 - buttonTextWidth/2, startButton.y + 5)
    
    -- Draw instructions
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.printf("Use W/S or Arrow Keys to move\nSpace to shoot lasers", 0, 400, 800, "center")
end

function menu.mousepressed(x, y, button)
    if button == 1 and
       x > startButton.x and x < startButton.x + startButton.w and
       y > startButton.y and y < startButton.y + startButton.h then
        return "game"
    end
end

function menu.keypressed(key)
    if key == "return" or key == "space" then
        return "game"
    end
end

return menu 