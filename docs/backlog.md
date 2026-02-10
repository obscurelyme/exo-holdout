# Exo Holdout - MVP Development Backlog

**Project:** Exo Holdout - 2D Co-op Horde Shooter  
**Target:** Minimum Viable Product (MVP) Release  
**Last Updated:** 2026-02-10

---

## 🎯 MVP Goals

- Host/Join P2P multiplayer working
- 1 playable arena
- 3 weapon types
- 4 enemy types + 1 mini-boss
- 10 waves with progression
- 6 perks system
- Basic UI (HP, wave counter, ammo)

---

## 📋 Kanban Board

### ✅ Done

_(Tasks completed will be moved here)_

---

### 🚧 In Progress

_(Currently active tasks)_

---

### 📝 To Do

#### **🏗️ Core Systems** (Est: 16-20 hours)

- [ ] **Setup Godot Project Structure** (2 hrs)
  - Configure project settings
  - Set up scene hierarchy (Main → Lobby → Game)
  - Create folder structure (scripts, scenes, assets, resources)
  - Configure physics engine (Jolt Physics)

- [ ] **Implement Game State Manager** (3 hrs)
  - Main menu state
  - Lobby state
  - Game state
  - Game over state
  - State transitions and signals

- [ ] **Wave Management System** (4 hrs)
  - Wave counter and progression
  - Wave start/end logic
  - Wave difficulty scaling
  - Inter-wave timer (shop phase)
  - Mini-boss trigger every 5 waves

- [ ] **Resource Management** (2 hrs)
  - Credits/currency system
  - Resource drops from enemies
  - Pickup collection logic

- [ ] **Camera System** (2 hrs)
  - Top-down camera setup
  - Smooth camera follow for single player
  - Multi-player camera (zoom out based on player spread)
  - Camera bounds for arena

- [ ] **Arena/World Setup** (3 hrs)
  - Create TileMap for derelict platform
  - Add spawn points (enemies and players)
  - Environmental props and obstacles
  - Collision layers setup

---

#### **🌐 Networking & Multiplayer** (Est: 14-18 hours)

- [ ] **Lobby System - Host** (3 hrs)
  - Create lobby UI
  - Host server creation (ENetMultiplayerPeer)
  - Display host IP and port
  - Player ready system
  - Start game broadcast

- [ ] **Lobby System - Join** (3 hrs)
  - Join UI with IP input
  - Client connection logic
  - Display connected players
  - Ready toggle system

- [ ] **Player Synchronization** (4 hrs)
  - MultiplayerSynchronizer setup for players
  - Position/rotation replication
  - Health/state sync
  - Input prediction (optional)
  - Interpolation for smooth movement

- [ ] **Host Authority Implementation** (5 hrs)
  - Host handles all game logic
  - Client input submission via RPC
  - Server-side damage calculation
  - Enemy spawning on host only
  - State replication to clients

- [ ] **Network Testing & Debugging** (3 hrs)
  - Test with 2-4 players
  - Latency handling
  - Disconnect/reconnect handling
  - Edge case testing

---

#### **🎮 Player Systems** (Est: 18-22 hours)

- [ ] **Player Character Controller** (4 hrs)
  - 8-directional movement (WASD)
  - Mouse/twin-stick aiming
  - Movement speed and friction
  - Player sprite and animations
  - Collision detection

- [ ] **Player Health System** (2 hrs)
  - HP tracking
  - Damage application
  - Death/revival system
  - Shield mechanics (optional)

- [ ] **Weapon System - Base** (4 hrs)
  - Weapon resource class
  - Fire rate system
  - Ammo/magazine system (or unlimited)
  - Weapon switching
  - Projectile spawning

- [ ] **Weapon Implementation - Pulse Pistol** (2 hrs)
  - Accurate, medium rate fire
  - Projectile behavior
  - Visual effects (muzzle flash, bullet trail)
  - Sound effects

- [ ] **Weapon Implementation - Scatter Blaster** (2 hrs)
  - Short range, high burst damage
  - Multiple projectiles per shot
  - Spread pattern
  - Visual and sound effects

- [ ] **Weapon Implementation - Arc SMG** (2 hrs)
  - Fast fire rate, low damage
  - Bullet spread
  - Visual effects (electric arc theme)
  - Sound effects

- [ ] **Secondary Skills** (4 hrs)
  - Dash ability
  - Shield ability
  - EMP ability
  - Cooldown system

---

#### **👾 Enemy Systems** (Est: 16-20 hours)

- [ ] **Enemy Base Class** (3 hrs)
  - Health system
  - Movement AI base
  - Damage on contact/attack
  - Death and cleanup
  - Drop spawning on death

- [ ] **Enemy Spawning System** (4 hrs)
  - Spawn point management
  - Wave-based spawn scheduling
  - Enemy type distribution
  - Spawn animations/effects

- [ ] **Enemy - Crawler** (2 hrs)
  - Slow melee behavior
  - Pathfinding to nearest player
  - Attack animation and damage
  - Sprite and effects

- [ ] **Enemy - Skitter** (2 hrs)
  - Fast movement, low HP
  - Erratic movement patterns
  - Quick attacks
  - Sprite and effects

- [ ] **Enemy - Spitter** (2 hrs)
  - Ranged projectile attacks
  - Keep distance from players
  - Projectile spawning
  - Sprite and effects

- [ ] **Enemy - Bulwark** (3 hrs)
  - Slow tank with high HP
  - Enhanced credit drops
  - Strong attacks
  - Sprite and effects

- [ ] **Mini-Boss - The Warden** (5 hrs)
  - Rotating laser sweep attack
  - Minion summoning
  - Phase transitions
  - Boss health bar UI
  - Defeat condition

---

#### **⚡ Perks & Upgrades** (Est: 10-12 hours)

- [ ] **Perk System Architecture** (4 hrs)
  - Perk resource definitions
  - Player perk inventory
  - Perk application logic
  - Perk stacking rules

- [ ] **Shop UI** (4 hrs)
  - Inter-wave shop screen
  - Random perk selection (2 options)
  - Perk descriptions and costs
  - Purchase logic

- [ ] **Implement All 6 Perks** (4 hrs)
  - Overclocked Barrel (+fire rate)
  - Magnetized Rounds (+auto-aim)
  - Reactive Plating (+max HP)
  - Field Recharger (+shield regen)
  - Volatile Capacitor (+crit chance)
  - Kinetic Repulsor (+knockback)

---

#### **🎨 UI & HUD** (Est: 12-14 hours)

- [ ] **Main Menu** (3 hrs)
  - Title screen
  - Host/Join buttons
  - Settings (audio, controls)
  - Quit button

- [ ] **In-Game HUD** (4 hrs)
  - Health bar
  - Wave counter
  - Ammo display
  - Credits/currency display
  - Ability cooldown indicators

- [ ] **Pause Menu** (2 hrs)
  - Pause functionality
  - Resume/quit options
  - Settings access

- [ ] **Game Over Screen** (2 hrs)
  - Victory screen (wave 10 complete)
  - Defeat screen (all players down)
  - Stats display (waves survived, kills, etc.)
  - Return to lobby/quit options

- [ ] **Player Nameplate/Indicators** (2 hrs)
  - Player names above characters
  - Health bars for other players
  - Team color coding

---

#### **✨ Polish & Audio** (Est: 8-10 hours)

- [ ] **Visual Effects** (4 hrs)
  - Particle effects for weapons
  - Explosion effects
  - Hit effects
  - Bloom/glow effects
  - Debris and sparks

- [ ] **Sound Effects** (3 hrs)
  - Weapon firing sounds
  - Impact sounds
  - Enemy death sounds
  - UI click sounds
  - Player hit/death sounds

- [ ] **Background Music** (2 hrs)
  - Ambient menu music
  - In-game tension music
  - Boss fight music
  - Victory/defeat stingers

- [ ] **Screen Shake & Juice** (2 hrs)
  - Camera shake on hits
  - Hit-stop effects
  - Damage numbers (optional)

---

#### **🧪 Testing & Bug Fixes** (Est: 8-10 hours)

- [ ] **Single Player Testing** (2 hrs)
  - Full playthrough testing
  - Balance adjustments
  - Bug fixes

- [ ] **Multiplayer Testing** (3 hrs)
  - 2-4 player testing
  - Network stability
  - Synchronization issues
  - Balance for multiple players

- [ ] **Win/Loss Condition Testing** (1 hr)
  - Wave 10 victory
  - All players down defeat
  - Edge cases

- [ ] **Performance Optimization** (3 hrs)
  - Profile frame rate
  - Optimize particle effects
  - Reduce draw calls
  - Network bandwidth optimization

---

#### **📦 Build & Release** (Est: 4-6 hours)

- [ ] **Windows Build Setup** (2 hrs)
  - Export settings configuration
  - Icon and metadata
  - Test exported build

- [ ] **Itch.io Release** (2 hrs)
  - Create itch.io page
  - Upload build
  - Write description
  - Add screenshots

- [ ] **Documentation** (2 hrs)
  - Player guide/controls
  - Known issues
  - Credits

---

## 📊 Effort Summary

| Category | Estimated Hours |
|----------|----------------|
| Core Systems | 16-20 |
| Networking & Multiplayer | 14-18 |
| Player Systems | 18-22 |
| Enemy Systems | 16-20 |
| Perks & Upgrades | 10-12 |
| UI & HUD | 12-14 |
| Polish & Audio | 8-10 |
| Testing & Bug Fixes | 8-10 |
| Build & Release | 4-6 |
| **TOTAL** | **106-132 hours** |

---

## 🏃 Sprint Recommendations

### Sprint 1: Foundation (Weeks 1-2)
- Core Systems
- Networking & Multiplayer basics
- Player Character Controller

### Sprint 2: Combat (Weeks 3-4)
- Weapon Systems
- Enemy Systems
- Basic HUD

### Sprint 3: Progression (Weeks 5-6)
- Wave Management
- Perks & Upgrades
- Mini-Boss

### Sprint 4: Polish (Week 7-8)
- UI completion
- Audio & Visual effects
- Testing & Bug fixes
- Build & Release

---

## 📌 Notes

- Tasks are organized by functional area for easier team assignment
- Time estimates are for a single developer; adjust for team size
- Networking tasks should be tackled early to validate architecture
- Visual and audio polish can be done in parallel with other work
- Regular playtesting after Sprint 2 is recommended

---

## 🔗 Related Documents

- [Game Design Document](./gdd.md) - Full design specifications
- [README.md](../README.md) - Project overview
