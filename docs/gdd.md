# Game Design Document — _Exo Holdout_

## 1. High‑Level Summary

**Genre:** 2D co‑op horde shooter  
**Platform:** Itch.io (desktop build; Win32 only) - Steam release later
**Engine:** Godot (4.6-stable)  
**Monetization:** Free  
**Players:** 1–4  
**Networking:** Peer‑to‑peer (host authoritative) with optional Steam P2P later

---

## 2. Theme & Setting (Sci‑Fi)

- **Setting:** A derelict orbital mining platform drifting above a gas giant.
- **Player Role:** Salvage crew in exo‑rigs sent to recover data cores.
- **Enemy Concept:** Bio‑mechanical swarms attracted to power spikes.
- **Visuals:** High‑contrast top‑down lighting, neon UI, particle sparks, metal textures.

---

## 3. Core Gameplay Loop

1. **Wave begins** (short countdown)
2. **Enemies spawn** from vents/doors
3. **Players eliminate enemies**
4. **Drops** (credits + upgrades)
5. **Inter‑wave shop** (pick 1 of 2 random perks)
6. **Repeat** → **Mini‑boss every 5 waves**

---

## 4. Mechanics

### Player Actions

- **Movement:** 8‑directional (WASD / stick)
- **Aiming:** Twin‑stick or mouse aim
- **Primary Fire:** Continuous fire (weapon‑specific rate)
- **Secondary Skill:** Utility per player (dash, shield, EMP)

### Weapons (Initial 3)

1. **Pulse Pistol** (accurate, medium rate)
2. **Scatter Blaster** (short range, high burst)
3. **Arc SMG** (fast, low damage, spread)

### Perks (Initial 6)

- **Overclocked Barrel** (+fire rate)
- **Magnetized Rounds** (+auto‑aim assist)
- **Reactive Plating** (+max HP)
- **Field Recharger** (+shield regen)
- **Volatile Capacitor** (+crit chance)
- **Kinetic Repulsor** (+knockback)

### Enemies (Initial 4)

- **Crawler** (slow melee)
- **Skitter** (fast low HP)
- **Spitter** (ranged projectile)
- **Bulwark** (slow tank, drops extra credits)

### Mini‑Boss (Wave 5)

- **The Warden**: Rotating laser sweep + summon minions.

---

## 5. Win/Loss Conditions

- **Win:** Defeat wave 10 + final mini‑boss
- **Loss:** All players downed simultaneously

---

# 6. Multiplayer Architecture (Detailed)

### High‑Level Approach

**Host‑authoritative P2P** using Godot’s ENet transport.

- One player **hosts** and acts as **server**.
- Other players **join** by IP + UDP port.
- **Clients send inputs**, host simulates.
- Host **replicates authoritative state**.

This is simpler than a dedicated server and is cheap to operate.

---

## 6.1 Godot Networking Concepts (Docs)

**Core Godot docs:**

- Multiplayer API overview  
  https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html
- RPC usage  
  https://docs.godotengine.org/en/stable/tutorials/networking/rpcs.html
- ENetMultiplayerPeer (UDP)  
  https://docs.godotengine.org/en/stable/classes/class_enetmultiplayerpeer.html
- Scene replication & authority  
  https://docs.godotengine.org/en/stable/tutorials/networking/multiplayer_with_scene_replication.html

---

## 6.2 Example Projects / Reference Material

- **Godot demo projects list**  
  https://github.com/godotengine/godot-demo-projects  
  (Contains multiplayer demos you can inspect)
- **High‑level multiplayer demo (Godot 4)**  
  https://github.com/godotengine/godot-demo-projects/tree/master/networking
- **ENet example (Godot 4 docs)**  
  https://docs.godotengine.org/en/stable/tutorials/networking/high_level_multiplayer.html#enet

---

## 6.3 Multiplayer Structure (Recommended)

### Scene Authority

- **Host** owns authoritative state:
  - Enemy spawns
  - Enemy AI
  - Damage calculations
  - Loot drops
  - Wave progression

### Client Responsibilities

- Collect local input
- Send to host
- Predict movement (optional small prediction)
- Render replicated state

### RPC Strategy

- **Client → Host RPCs**
  - `rpc_id(host_id, "submit_input", input_payload)`
- **Host → Clients RPCs**
  - `rpc("spawn_enemy", enemy_type, position)`
  - `rpc("sync_player_state", state_payload)`
  - `rpc("apply_damage", target_id, amount)`

### State Sync

- Use **MultiplayerSynchronizer** for player nodes.
- Server updates transform, velocity, health.
- Use **interpolation** on clients.

---

## 6.4 Ports & Connection (P2P)

- Host opens UDP port, e.g. **2456**
- Players join via external IP + port
- Display host’s IP on “Create Lobby” screen

---

## 6.5 Steam Considerations (Future)

- Replace direct IP join with **Steam P2P / lobbies**
- Godot has community Steamworks plugins (e.g., GodotSteam)
- Still possible to keep ENet for gameplay and only use Steam for lobby / NAT traversal
- Most NAT traversal handled automatically

---

# 7. Scene Structure (Proposed)

```
Main
├── Lobby (UI)
├── Game
│   ├── World (TileMap, props)
│   ├── PlayerManager
│   ├── EnemyManager
│   ├── WaveManager
│   ├── DropManager
│   ├── UI
```

---

# 8. Audio & Visual Goals

- **SFX:** plasma shots, metallic impacts
- **Music:** ambient synth, tension ramps
- **FX:** bloom glow, sparks, debris, trails

---

# 9. MVP Checklist

- [ ] Host / Join P2P working
- [ ] 1 arena
- [ ] 3 weapons
- [ ] 4 enemy types
- [ ] 10 waves
- [ ] 6 perks
- [ ] Basic UI (HP, wave, ammo)

---

# 10. Next Steps (If You Want)

I can generate:

- A **technical task list** (Godot‑specific)
- A **networking flowchart**
- **GDScript prototypes** for RPC input/state replication
- A **Steam migration plan**
