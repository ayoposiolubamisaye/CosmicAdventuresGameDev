local function createParticleTexture()
    -- Create white dots
    local imageData = love.image.newImageData(2, 2)
    
    -- Make all pixels white
    for y = 0, 1 do
        for x = 0, 1 do
            imageData:setPixel(x, y, 1, 1, 1, 1)  -- fullyopaque
        end
    end
    
    return love.graphics.newImage(imageData)
end

return createParticleTexture 