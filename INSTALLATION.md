# 📦 Installation Guide

This guide will walk you through the complete installation process for **ritwik-houserobberies**.

## ⚠️ CRITICAL WARNING
**DO NOT CHANGE THE RESOURCE NAME `ritwik-houserobberies` UNDER ANY CIRCUMSTANCES!**
The system has hardcoded references throughout that depend on this exact name. Changing it will break all functionality.

## 📋 Pre-Installation Checklist

Before installing, ensure you have:

- ✅ **QBCore Framework** (Latest version)
- ✅ **ox_lib** (Required for UI and skillchecks)
- ✅ **Server console access** (For resource management)
- ✅ **Database access** (No database changes needed, but good to have)
- ✅ **FTP/File access** to your server

### Optional but Recommended:
- ⭐ **ps-ui** (For advanced minigames)
- ⭐ **okok-notify** (Enhanced notifications)
- ⭐ **Dispatch system** (ps-dispatch, aty_dispatch, etc.)

## 🚀 Step-by-Step Installation

### Step 1: Download the Resource

1. **Download** the latest release from GitHub
2. **Extract** the zip file
3. **Rename** the folder to exactly `ritwik-houserobberies` (if not already)
4. **Place** in your server's `[scripts]` folder

```
📁 resources/
  📁 [scripts]/
    📁 ritwik-houserobberies/
      📄 fxmanifest.lua
      📄 config.lua
      📄 README.md
      📁 client/
      📁 server/
      📁 install/
```

### Step 2: Add Items to Your Inventory

#### For QB-Inventory / LJ-Inventory:

1. **Open** `qb-core/shared/items.lua`
2. **Add** the following items:

```lua
-- House Breaking Tools
['lockpick'] = {['name'] = 'lockpick', ['label'] = 'Lockpick', ['weight'] = 100, ['type'] = 'item', ['image'] = 'lockpick.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Useful for opening locked doors'},
['screwdriverset'] = {['name'] = 'screwdriverset', ['label'] = 'Screwdriver Set', ['weight'] = 200, ['type'] = 'item', ['image'] = 'screwdriverset.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Professional screwdriver set for advanced locks'},
['advancedlockpick'] = {['name'] = 'advancedlockpick', ['label'] = 'Advanced Lockpick', ['weight'] = 150, ['type'] = 'item', ['image'] = 'advancedlockpick.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Advanced lockpicking tool for high-security locks'},
['electronickit'] = {['name'] = 'electronickit', ['label'] = 'Electronic Kit', ['weight'] = 500, ['type'] = 'item', ['image'] = 'electronickit.png', ['unique'] = false, ['useable'] = true, ['shouldClose'] = true, ['description'] = 'Electronic hacking kit for the most secure locks'},

-- Black Market Items (Add all 37+ items from install/qbitems.md)
['art1'] = {['name'] = 'art1', ['label'] = 'Abstract Art', ['weight'] = 1000, ['type'] = 'item', ['image'] = 'art1.png', ['unique'] = false, ['useable'] = false, ['shouldClose'] = true, ['description'] = 'Valuable abstract artwork'},
-- ... (see install/qbitems.md for complete list)
```

#### For OX-Inventory:

1. **Open** `ox_inventory/data/items.lua`
2. **Add** the items from `install/oxitems.md`

### Step 3: Add Item Images

1. **Copy** all images from `install/images/` folder
2. **Paste** to your inventory's image directory:
   - **QB-Inventory**: `qb-inventory/html/images/`
   - **OX-Inventory**: `ox_inventory/web/images/`
   - **LJ-Inventory**: `lj-inventory/html/images/`

### Step 4: Configure the Resource

1. **Open** `config.lua`
2. **Configure** these settings for your server:

```lua
-- Basic Configuration
Config.Notify = 'ox' -- Change to 'qb' or 'okok' based on your preference
Config.progressbartype = 'oxbar' -- 'oxbar', 'oxcir', or 'qb'
Config.minigametype = 'ox' -- See Config.Minigames for all options

-- Cooldown System
Config.RobberyCooldown = 600 -- 10 minutes (adjust as needed)
Config.CooldownMessage = "You need to wait %s before you can rob another house!"

-- Tech Guy System
Config.TechGuyChangeTime = 60 -- Location change time in minutes (adjust as needed)
```

### Step 5: Server Configuration

1. **Add** to your `server.cfg`:
```
ensure ritwik-houserobberies
```

2. **Make sure** it loads AFTER dependencies:
```
ensure qb-core
ensure ox_lib
ensure ps-ui  # if using
ensure ritwik-houserobberies
```

### Step 6: Start the Resource

1. **Restart** your server or use:
```
start ritwik-houserobberies
```

2. **Check console** for any errors
3. **Look for** successful loading messages

## ✅ Post-Installation Testing

### Test Basic Functionality

1. **Join** your server
2. **Find** a house location (check locations in config.lua)
3. **Try** to break in with appropriate tools
4. **Verify** minigames work
5. **Check** loot spawning

### Test Cooldown System

1. **Successfully** rob a house
2. **Try** to rob another house immediately
3. **Should** see cooldown message

## 🔧 Common Issues & Solutions

### Issue: "Resource failed to start"
**Solution**: 
- Check console for specific errors
- Ensure all dependencies are installed
- Verify resource name is exactly `ritwik-houserobberies`

### Issue: "Items not showing in inventory"
**Solution**:
- Double-check item additions to items.lua
- Restart qb-core after adding items
- Verify image files are in correct location

### Issue: "Minigames not appearing"
**Solution**:
- Ensure ps-ui is installed if using ps minigames
- Check Config.minigametype setting
- Verify ox_lib is properly loaded

### Issue: "Cooldown not working"
**Solution**:
- Check server console for any error messages
- Verify Steam/License identifiers are working
- Test by attempting consecutive house robberies

## 🎯 Configuration Tips

### Economy Balancing
- **Default**: $25K-50K per hour potential
- **Adjust**: Black Market values in config.lua
- **Monitor**: Player economy impact

### Cooldown Tuning
- **Casual servers**: 300-600 seconds (5-10 minutes)
- **Hardcore servers**: 1800-3600 seconds (30-60 minutes)
- **Testing**: Use shorter times initially

### Minigame Difficulty
```lua
Config.Minigames = {
    ox = {'easy', 'easy'}, -- Beginner friendly
    ox = {'medium', 'hard'}, -- Experienced players
    ox = {'hard', 'hard'}, -- Expert level
}
```

## 📞 Support

If you encounter issues:

1. **Check** this installation guide thoroughly
2. **Search** existing GitHub issues
3. **Create** a detailed issue report if needed
4. **Include** server console logs and specific error messages

## ✅ Installation Complete!

Your **ritwik-houserobberies** system should now be fully operational with:
- ✅ House robbery functionality
- ✅ Cooldown system active
- ✅ Tech Guy intel system with dynamic spawning
- ✅ Black Market economy integrated
- ✅ Multiple minigame support

**Happy Robbing! 🏠💰**
