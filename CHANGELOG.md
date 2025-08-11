# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.0] - 2025-08-11

### Added
- **Comprehensive Cooldown System**
  - Steam ID and License identifier tracking
  - Configurable cooldown timers (default 10 minutes)
  - Persistent cooldowns across player sessions
  - Custom cooldown messages with time formatting

- **Enhanced Economy System**
  - Black Market integration with 37+ unique items
  - Balanced pricing system ($25 - $2,500 per item)
  - Proper item removal and money addition
  - Hourly earning potential: $25,000 - $50,000

- **Tech Guy Intel System**
  - Dynamic NPC spawning system with location changes every hour
  - Tier-based house information purchasing ($100-$1000)
  - Multiple spawn locations for realistic gameplay
  - Strategic advantage for planned robberies
  - Cash-based payment system

- **Advanced Animation System**
  - Animation persistence during minigames
  - Proper animation cleanup on completion/cancellation
  - "mini@repair" + "fixing_a_ped" animation integration

- **Multiple Minigame Support**
  - ps-ui: Circle, Maze, Scrambler, VarHack, Thermite
  - ox_lib: Skillcheck system with difficulty levels
  - bl-ui: Progress bar integrations
  - Fallback systems for missing dependencies

### Fixed
- **Critical Loot Spawning Bug**
  - Fixed variable shadowing issue in `enterRobberyHouse` function
  - Changed loop iterator from `k` to `obj` to prevent overwrites
  - Added model loading timeout handling
  - Improved object creation with proper error handling

- **Cooldown System Functionality**
  - Changed local functions to global scope
  - Fixed function accessibility in event handlers
  - Added comprehensive debug logging
  - Implemented fallback identifier systems

- **Model Loading Issues**
  - Replaced problematic `v_res_m_armoire` with `prop_rub_cabinet01`
  - Added timeout handling for model requests
  - Improved object deletion on cleanup

### Changed
- **Economy Rebalancing**
  - Adjusted all Black Market item values for server balance
  - Maintained original high-value items (Gold Bar, Diamond Ring, etc.)
  - Added new exclusive Black Market items
  - Optimized earning rates per tier

- **Configuration Structure**
  - Added cooldown configuration section
  - Reorganized config file for better readability
  - Added comprehensive comments for all options

### Performance
- **Memory Optimization**
  - Efficient cooldown tracking with automatic cleanup
  - Improved object spawning with proper disposal
  - Reduced unnecessary client-server communications
  - Optimized animation handling

- **Network Efficiency**
  - Minimized network events during robbery process
  - Efficient state synchronization between clients
  - Reduced server load with smart caching

## [1.0.0] - 2025-08-10

### Added
- Initial release based on md-houserobberies
- Basic house robbery system with 4 tiers
- Multiple minigame integrations
- Basic economy system
- House state management
- Player notification systems

### Features
- Tier-based house system (1-4)
- Multiple tool requirements per tier
- Basic loot spawning system
- QBCore framework integration
- Multiple notification system support
- Basic progress bar integrations

---

## Upgrade Instructions

### From 1.0.0 to 2.0.0

1. **Backup your current configuration**
2. **Update all files** with new versions
3. **Add new configuration options** to `config.lua`:
   ```lua
   Config.RobberyCooldown = 600
   Config.CooldownMessage = "You need to wait %s before you can rob another house!"
   ```
4. **Restart the resource** completely
5. **Test cooldown system** by attempting consecutive house robberies

### Breaking Changes
- None - Fully backward compatible

### Deprecated Features
- None in this release

---

## Support

For issues, feature requests, or questions:
- **GitHub Issues**: [Create an issue](https://github.com/YourUsername/ritwik-houserobberies/issues)
- **Documentation**: Check README.md for detailed information
- **Community**: Join our Discord server for support
