# cmdr-additions

**cmdr-additions is still largely incomplete. Use with caution.**

An extension for [Cmdr](https://github.com/evaera/Cmdr) that provides additional functionality you would expect from a traditional Roblox "admin commands" suite.

cmdr-additions tries to be as un-intrusive as possible, allowing use alongside Cmdr in all Roblox games.

Forking this repository is encouraged if you wish to add any functionality that may be specific to your game but isn't achievable with the Cmdr API, including but not limited to:
- UI modifications
- Modified functionality for certain commands
- Translations to other languages

## Installation

### With Rojo

TODO

### Without Rojo

TODO

## Initialization

On both the client and the server:
- Initialize Cmdr using the setup guide on the [Cmdr website](https://eryn.io/Cmdr/).
- Create a new instance of CmdrAdditions with config provided (see [here](Demo/Config.lua) for an example).
- Call `:Register(cmdr)`, providing either the Cmdr or CmdrClient object depending on which applies.

```lua
CmdrAdditions.new(config):Register(Cmdr)
```

## Configuration

TODO (see [here](Demo/Config.lua) for an example)

## Features

TODO

## Commands

Note: There are *plenty* more commands planned.

### Message
`message`, `m`

Shows a message that covers all players' screens.

Arguments:
- `string` Message — The message to show

### Server message
`servermessage`, `sm`

Like the `message` command, but without author details.

Arguments:
- `string` Message — The message to show

### Teleport
`teleport`, `tp`

Teleports players to a player.

Arguments:
- `players` Players — The players to teleport
- `player` Target player — The player to teleport to

### To
`to`, `goto`

Teleports you to a player.

Arguments:
- `player` Target player — The player to teleport to

### Bring
`bring`

Teleports players to you.

Arguments:
- `players` Players — The players to bring

### Forcefield
`forcefield`, `ff`

Gives players a forcefield.

Arguments:
- `players` Players — The players to give a forcefield to

### Remove forcefield
`removeforcefield`, `unff`, `unforcefield`

Removes all forcefields that are on players' characters.

Arguments:
- `players` Players — The players to remove forcefields from

### Respawn
`respawn`

Respawns players' characters.

Arguments:
- `players` Players — The players to respawn

### Refresh
`refresh`

Respawns players' characters, but keeps their old position.

Arguments:
- `players` Players — The players to refresh

### Kill
`kill`

Kills players by running BreakJoints on their character.

Arguments:
- `players` Players — The players to kill

### Uptime
`uptime`

Shows how long the server has been up for.

# Contributing

cmdr-additions requires [Rojo](https://github.com/roblox/rojo) 0.6.0 or above to sync properly. Once you have that installed, run:

```
rojo serve demo.project.json
```

Use the Roblox Studio plugin to sync into any place you wish (preferably an empty baseplate!) and you're good to go. Rojo will automatically keep any changes up to date, allowing you to play-test at any time.

# License

cmdr-additions is available under the MIT license. See [LICENSE](LICENSE) for details.

Please note that included dependencies may have different licenses.