local menu = {}

-- Menu state variables
local stars = {}
local startButton = {
    x = 300,
    y = 250,
    width = 200,
    height = 50,
    text = "ENTER",
    hover = false
}

function menu.load()
    -- Initialize background stars
    for i = 1, 40 do
        table.insert(stars, {
            x = love.math.random(0, 800), -- random x of stars
            y = love.math.random(0, 600), -- random y of stars
            size = love.math.random(1, 3), -- changes size of stars
            speed = love.math.random(50, 100) -- changes speed of stars
        })
    end
end

function menu.update(dt)
    -- Update the stars x and y positions
    for _, star in ipairs(stars) do
        star.x = star.x - star.speed * dt
        if star.x < 0 then
            star.x = 800
            star.y = love.math.random(0, 600)
        end
    end
    
    -- Check mouse hover over start button
    local mouseX, mouseY = love.mouse.getPosition()
    startButton.hover = mouseX >= startButton.x and
                       mouseX <= startButton.x + startButton.width and
                       mouseY >= startButton.y and
                       mouseY <= startButton.y + startButton.height
end

function menu.draw()
    -- Draw background
    love.graphics.setBackgroundColor(0.05, 0.05, 0.1)
    
    -- Draw stars
    love.graphics.setColor(1, 1, 0)
    for _, star in ipairs(stars) do 
        love.graphics.circle("fill", star.x, star.y, star.size)
    end
    
    -- Draw title
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(50))
    love.graphics.printf("Cosmic Adventures", 0, 100, 800, "center")
    
    -- Names
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(25))
    love.graphics.printf("By: Brett and Ayoposi", 0, 180, 800, "center")

    -- Draw start button
    if startButton.hover then
        love.graphics.setColor(0.2, 0.6, 1)
    else
        love.graphics.setColor(0.1, 0.3, 0.5)
    end
    love.graphics.rectangle("fill", startButton.x, startButton.y, startButton.width, startButton.height)
    
    -- Draw button text
    love.graphics.setColor(1, 1, 1)
    love.graphics.setFont(love.graphics.newFont(24))
    love.graphics.printf(startButton.text, startButton.x, startButton.y + 10, startButton.width, "center")
    
    -- Draw instructions
    love.graphics.setFont(love.graphics.newFont(16))
    love.graphics.printf("Use W/S or Arrow Keys to move\nSpace to shoot lasers", 0, 400, 800, "center")
end

function menu.mousepressed(x, y, button)
    if button == 1 and startButton.hover then
        changeState("game")
    end
end

function menu.keypressed(key)
    if key == "return" or key == "space" then
        changeState("game")
    end
end

return menu 