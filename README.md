## 🏠 Ritwik House Robberies

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![FiveM](https://img.shields.io/badge/FiveM-Ready-blue.svg)](https://fivem.net/)
[![QBCore](https://img.shields.io/badge/QBCore-Compatible-green.svg)](https://github.com/qbcore-framework)

A comprehensive house robbery system for FiveM servers, built on QBCore framework with advanced features including cooldown systems, multiple minigames, and Black Market integration.

> **⚠️ CRITICAL WARNING: DO NOT CHANGE THE RESOURCE NAME `ritwik-houserobberies` UNDER ANY CIRCUMSTANCES! Changing the resource name will break all functionality.**

## 🎯 Features

### 🔥 Core Features

- **Multiple Minigame Support**: ps-ui (Circle, Maze, Scrambler, VarHack, Thermite), ox_lib skillchecks, bl-ui progress bars
- **Tier-Based Houses**: 4 different house tiers with increasing difficulty and rewards
- **Dynamic Economy**: Black Market system with 37+ unique items and balanced pricing
- **Cooldown System**: Prevents exploitation with configurable cooldown timers
- **Tech Guy Intel System**: Purchase house information for strategic planning

### 🛡️ Security & Balance

- **Steam ID/License Tracking**: Persistent cooldowns across sessions
- **Smart Spawning**: Fixed loot spawning system with timeout handling
- **Animation Persistence**: Proper animation handling during minigames
- **Dynamic NPC System**: Tech Guy changes locations every hour for realism

### 🎮 Player Experience

- **Multiple Progress Bar Types**: ox_lib bars/circles, QBCore progress bars
- **Flexible Notifications**: Support for ox_lib, QBCore, and okok notifications
- **Intel Purchase System**: Buy house information from Tech Guy for strategic advantage
- **Dispatch Integration**: Compatible with ps-dispatch, aty_dispatch, qs-dispatch, cd_dispatch

## 📋 Requirements

### Required Dependencies

- **QBCore Framework** - Latest version
- **ox_lib** - For UI components and skillchecks
- **ps-ui** - For advanced minigames (Circle, Maze, Scrambler, VarHack, Thermite)
- **k4mb1 free shells** - For house interior shells

### Optional Dependencies

- **okok Notify** - For enhanced notifications
- **Various Dispatch Systems** - ps-dispatch, aty_dispatch, qs-dispatch, cd_dispatch

## 🔧 Installation

### 1. Download and Setup

```bash
# Clone or download the resource
git clone https://github.com/YourUsername/ritwik-houserobberies.git

# Place in your resources folder
[scripts]/ritwik-houserobberies/
```

### 2. Database Setup

**No database setup required!** This script uses server memory for cooldown tracking.

### 3. Add Items to Your Inventory

Choose your inventory system and add the items:

#### QB-Inventory / LJ-Inventory

Add to `qb-core/shared/items.lua`:

```lua
-- House Robbery Items
['lockpick'] = {['name'] = 'lockpick', ['label'] = 'Lockpick', ['weight'] = 100, ['type'] = 'item', ['image'] = 'lockpick.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Useful for opening locked doors'},
['screwdriverset'] = {['name'] = 'screwdriverset', ['label'] = 'Screwdriver Set', ['weight'] = 200, ['type'] = 'item', ['image'] = 'screwdriverset.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Professional screwdriver set for advanced locks'},
```

*See `/install/qbitems.md` for complete item list*

#### OX-Inventory

Add to `ox_inventory/data/items.lua`:

```lua
-- House Robbery Items
['lockpick'] = {
    label = 'Lockpick',
    weight = 100,
    stack = true,
    close = true,
    description = 'Useful for opening locked doors',
    client = {
        image = 'lockpick.png',
    }
},
```

*See `/install/oxitems.md` for complete item list*

### 4. Add Images

Copy all images from `/install/images/` to your inventory's image folder:

- **QB-Inventory**: `qb-inventory/html/images/`
- **OX-Inventory**: `ox_inventory/web/images/`
- **LJ-Inventory**: `lj-inventory/html/images/`

### 5. Server Configuration

Add to your `server.cfg`:

```
ensure ritwik-houserobberies
```

### 6. Resource Configuration

Edit `config.lua` to match your server setup:

```lua
Config.Notify = 'ox' -- 'qb', 'ox', or 'okok'
Config.progressbartype = 'oxbar' -- 'oxbar', 'oxcir', or 'qb'
Config.minigametype = 'ox' -- See Config.Minigames for options
Config.RobberyCooldown = 600 -- Cooldown in seconds (600 = 10 minutes)
Config.TechGuyChangeTime = 60 -- Tech Guy location change time in minutes
```

## ⚙️ Configuration

### House Tiers

- **Tier 1**: Basic houses - Lockpick required
- **Tier 2**: Medium security - Screwdriver Set required
- **Tier 3**: High security - Advanced Lockpick required
- **Tier 4**: Maximum security - Electronic Kit required

### Minigame Options

```lua
Config.Minigames = {
    ps_circle = { amount = 2, speed = 8 },
    ps_maze = { timelimit = 15 },
    ps_scrambler = { type = 'numeric', time = 15, mirrored = 0 },
    ps_var = { numBlocks = 5, time = 10 },
    ps_thermite = { time = 10, gridsize = 5, incorrect = 3 },
    ox = { 'easy', 'easy' }, -- 'easy', 'medium', or 'hard'
}
```

### Tech Guy Intel System

The Tech Guy provides valuable house intelligence for a fee:

- **Dynamic Spawning**: Changes location every hour (configurable)
- **Tier-Based Pricing**: $100-1000 depending on house difficulty
- **Strategic Advantage**: Get information before attempting robberies
- **Multiple Locations**: Spawns randomly across 4+ different locations
- **Payment Options**: Cash or item-based payment system

```lua
Config.TechGuyTierPrices = {
    [1] = 100,  -- Tier 1 houses
    [2] = 200,  -- Tier 2 houses  
    [3] = 350,  -- Tier 3 houses
    [4] = 500,  -- Tier 4 houses
}
```

### Economy Settings

- **Total Black Market Items**: 37 unique items
- **Value Range**: $25 - $2,500 per item
- **Hourly Potential**: $25,000 - $50,000 (balanced for server economy)

## 🎮 Usage

### For Players

1. **Acquire Tools**: Purchase lockpicks and tools from appropriate vendors
2. **Buy Intel** (Optional): Find the Tech Guy and purchase house information
3. **Find Houses**: Look for unlocked houses around the map
4. **Break In**: Use the correct tool for each tier
5. **Complete Minigames**: Successfully complete the minigame to proceed
6. **Loot Items**: Search containers for valuable items
7. **Sell Items**: Take items to Black Market dealers

### Tech Guy System

- **Location**: Changes every hour to random spawn points
- **Intel Service**: Purchase information about house tiers and difficulty
- **Pricing**: Tier 1 ($100) to Tier 4 ($500)
- **Payment**: Cash payment required
- **Strategic Value**: Know what you're getting into before breaking in

### House Mechanics

- **Spawning**: Houses spawn loot when first entered
- **Cooldowns**: Players must wait between robberies (configurable)
- **Persistence**: House states persist across server sessions
- **Anti-Exploitation**: Multiple systems prevent abuse

## 🛠️ Troubleshooting

### Common Issues

**Issue**: Minigames not appearing
**Solution**: Ensure ps-ui is installed and started before this resource

**Issue**: Items not spawning in houses
**Solution**: Check server console for model loading errors, restart resource

**Issue**: Cooldown not working
**Solution**: Verify server console for any errors, check Steam/License identifiers

## 📝 Changelog

### Version 2.0.0 (Latest)

- ✅ Added comprehensive cooldown system
- ✅ Fixed loot spawning variable shadowing bug
- ✅ Added Black Market economy integration
- ✅ Implemented Tech Guy intel system with dynamic spawning
- ✅ Enhanced animation persistence
- ✅ Added multiple minigame fallbacks
- ✅ Improved error handling

### Version 1.0.0 (Base)

- Initial release based on md-houserobberies
- Basic house robbery functionality
- Multiple tier system implementation

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Credits

- **Original Script**: [md-houserobberies](https://github.com/Mustachedom/md-houserobberies) by Mustachedom
- **Enhanced by**: Ritwik
- **QBCore Framework**: [QBCore Team](https://github.com/qbcore-framework)
- **ox_lib**: [Overextended Team](https://github.com/overextended/ox_lib)
- **ps-ui**: [Project Sloth](https://github.com/Project-Sloth/ps-ui)

## ⚠️ Important Notes

- **Resource Name**: Never change the resource name `ritwik-houserobberies`
- **Dependencies**: Ensure all required dependencies are installed and working
- **Economy**: Adjust Black Market prices according to your server's economy
- **Performance**: Script is optimized for minimal server impact
- **Support**: Create issues on GitHub for bugs and feature requests

## 📞 Support

- **GitHub Issues**: [Report bugs and request features](https://github.com/YourUsername/ritwik-houserobberies/issues)
- **Discord**: Join our Discord server for community support
- **Documentation**: Check this README and in-code comments for guidance

---

**Made with ❤️ for the FiveM community**

## Dependencies :

- [qb-core](https://github.com/qbcore-framework/qb-core)
- [ps-ui](https://github.com/Project-Sloth/ps-ui)
- [k4mb1 free shells](https://forum.cfx.re/t/free-props-starter-shells-for-housing-scripts/4826922)

## How to install like a boss

**step 1**

- delete qb-houserobbery

**step 2**

- Open the install folder
- **if** you use ox_inventory upload the items from the oxitems.md
- **if** you use any other inventory upload the items from the qbitems.md

**step 3**

- Modify `ritwik-houserobberies/config.lua` to your liking

<h1>Fivemerr</h1>
This is NOT a requirement but something I personally use and believe in.

- to integrate with fivemerr make sure you have  ``set fivemerrLogs "API_KEY"``   in your server.cfg
- Head to /server/bridge.lua and line 3 turn local logs = true
- profit

Why integrate with Fivemerr? Its a great place to store logs as it doesnt rely on discord webhooks and its far easier to search through

As well as a place to offload images and videos from fivem that doesnt rely on discord since discord API will be automatically deleting images and videos after a certain amount of time If you need an invite to their server look below

- [Fivemerr Discord](https://discord.com/invite/fivemerr)
- [Fivemerr Docs](https://docs.fivemerr.com/)
