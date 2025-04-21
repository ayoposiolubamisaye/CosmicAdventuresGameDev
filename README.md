# Cosmic Adventures

A space shooter game built with LÖVE (Love2D).

## Game Description
Navigate through space, collect stars for fuel, avoid or destroy asteroids, and collect power-ups to survive as long as possible!

## Features
- Spaceship movement with custom sprite
- Star collection for fuel and points
- Asteroid avoidance and destruction
- Laser shooting
- Power-ups (shield and speed boost)
- Particle effects
- Score tracking

## Controls
- W/S or Arrow Keys: Move up/down
- Space: Shoot lasers

## Requirements
- LÖVE 11.3 or later

## Installation
1. Download and install LÖVE from https://love2d.org/
2. Clone this repository
3. Run the game by dragging the folder onto the LÖVE executable

## Development
The game is organized into states:
- `main.lua`: Core game loop and state management
- `states/menu.lua`: Main menu
- `states/game.lua`: Gameplay
- `states/gameover.lua`: Game over screen
- `assets/particle.lua`: Particle system

## License
MIT License 