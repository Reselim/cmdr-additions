# cmdr-additions

**cmdr-additions is still largely incomplete. Use with caution.**

An extension for [Cmdr](https://github.com/evaera/Cmdr) that provides additional functionality you would expect from a traditional Roblox "admin commands" suite.

cmdr-additions tries to be as un-intrusive as possible, allowing use alongside Cmdr in all Roblox games.

Forking this repository is encouraged if you wish to add any functionality that may be specific to your game but isn't achievable with the Cmdr API, including but not limited to:
- UI modifications
- Modified functionality for certain commands
- Translations to other languages

## Features

TODO

## Installation

### With Rojo

Add this repository as a submodule to your project. This assumes you wish to clone it into a `Packages` directory. Don't forget to initialize submodules!

```
git submodule add https://github.com/Reselim/cmdr-additions.git Packages/CmdrAdditions
git submodule update --init --recursive
```

You can also clone it if you don't have a git repository set up in your project.

```
git clone https://github.com/Reselim/cmdr-additions.git Packages/CmdrAdditions
cd Packages/CmdrAdditions
git submodule init
```

#### 0.6+

If you have the `Packages` directory already syncing in, you're good to go! cmdr-additions will be added as normal thanks to having a [project file](default.project.json) with no root.

#### 0.5

Add cmdr-additions as a synced in directory wherever you wish, and add a Folder object named "Packages" inside with all of the dependencies, according to the [project file](default.project.json).

```json
"CmdrAdditions": {
	"$path": "Packages/CmdrAdditions",

	"Packages": {
		"$className": "Folder",

		"Roact": { "$path": "Packages/Roact" },
		"Flipper": { "$path": "Packages/Flipper" },
		"RoactFlipper": { "$path": "Packages/RoactFlipper" },
		"Promise": { "$path": "Packages/Promise/lib" },
		"Util": { "$path": "Packages/Util" }
	}
}
```

You can supplement the paths of these dependencies with ones already in your Packages directory, but it's recommended to use the ones provided by cmdr-additions to make sure the version is compatible.

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

## Commands

Note: There are *plenty* more commands planned.

### Message
`message`, `m`

Shows a message that covers all players' screens.

Arguments:
- `string` Content — The content of the message to show

### Server message
`servermessage`, `sm`

Like the `message` command, but without author details.

Arguments:
- `string` Content — The content of the message to show

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

### SetWalkSpeed
`setwalkspeed`, `walkspeed`, `ws`

Updates the WalkSpeed property on players' humanoids.

Arguments:
- `players` Players — The players to update
- `number` Walk speed — Maximum walking speed, measured in studs per second

### SetJumpPower
`setjumppower`, `jumppower`, `jp`

Updates the JumpPower property on players' humanoids.

Arguments:
- `players` Players — The players to update
- `number` Jump power

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

### Sit
`sit`

Makes a player sit.

Arguments:
- `players` Players — The players to sit

### Stun
`stun`, `platformstand`

Stuns players by setting PlatformStand on their humanoids to true.

Arguments:
- `players` Players — The players to stun

### Jump
`jump`, `unstun`, `unplatformstand`

Makes players jump; also sets PlatformStand to false.

Arguments:
- `players` Players — The players to make jump

### SetGravityModifier
`setgravitymodifier`, `setgrav`, `grav`

Sets characters' gravity compared to the global gravity.

Arguments:
- `players` Players — The players to change gravity for
- `number` Gravity modifier — The ratio of character gravity to global gravity; 0 for no gravity, 1 for default

## Expanding cmdr-additions

TODO

## Contributing

cmdr-additions requires [Rojo](https://github.com/roblox/rojo) 0.6.0 or above to sync properly. Once you have that installed, run:

```
rojo serve Demo
```

Use the Roblox Studio plugin to sync into any place you wish (preferably an empty baseplate!) and you're good to go. Rojo will automatically keep any changes up to date, allowing you to play-test at any time.

# License

cmdr-additions is available under the MIT license. See [LICENSE](LICENSE) for details.

Please note that included dependencies may have different licenses.