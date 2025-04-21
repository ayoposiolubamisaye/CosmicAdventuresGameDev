-- game states
local states = {
    menu = require("states.menu"),
    game = require("states.game.state"),
    gameover = require("states.gameover")
}

local currentState = "menu"

-- change game state
function changeState(newState)
    if states[newState] and states[newState].enter then
        currentState = newState
        states[currentState].enter()
    end
end

-- Love2d callbacks
function love.load()
    love.window.setTitle("Cosmic Adventures")
    love.window.setMode(800, 600, {resizable = false, vsync = true})
    
    --load states
    for _, state in pairs(states) do
        if state.load then
            pcall(state.load)
        end
    end
    
    --first state
    if states[currentState].enter then
        states[currentState].enter()
    end
end

function love.update(dt)
    if states[currentState] and states[currentState].update then
        local nextState = states[currentState].update(dt)
        if nextState then
            changeState(nextState)
        end
    end
end

function love.draw()
    if states[currentState] and states[currentState].draw then
        states[currentState].draw()
    end
end

function love.keypressed(key)
    if states[currentState] and states[currentState].keypressed then
        local nextState = states[currentState].keypressed(key)
        if nextState then
            changeState(nextState)
        end
    end
end

function love.mousepressed(x, y, button)
    if states[currentState] and states[currentState].mousepressed then
        local nextState = states[currentState].mousepressed(x, y, button)
        if nextState then
            changeState(nextState)
        end
    end
end 