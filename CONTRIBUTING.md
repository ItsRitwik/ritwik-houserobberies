# Contributing to Ritwik House Robberies

First off, thank you for considering contributing to ritwik-houserobberies! It's people like you that make the FiveM community great.

## Code of Conduct

This project and everyone participating in it is governed by our Code of Conduct. By participating, you are expected to uphold this code.

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check the existing issues as you might find out that you don't need to create one. When you are creating a bug report, please include as many details as possible.

#### How Do I Submit A Good Bug Report?

Bugs are tracked as [GitHub issues](https://github.com/YourUsername/ritwik-houserobberies/issues). Create an issue and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the problem.
* **Describe the exact steps which reproduce the problem** in as many details as possible.
* **Provide specific examples to demonstrate the steps**.
* **Describe the behavior you observed after following the steps** and point out what exactly is the problem with that behavior.
* **Explain which behavior you expected to see instead and why.**
* **Include server console logs** if relevant.
* **Include client console (F8) output** if relevant.

### Suggesting Enhancements

Enhancement suggestions are tracked as [GitHub issues](https://github.com/YourUsername/ritwik-houserobberies/issues). Create an issue and provide the following information:

* **Use a clear and descriptive title** for the issue to identify the suggestion.
* **Provide a step-by-step description of the suggested enhancement** in as many details as possible.
* **Provide specific examples to demonstrate the steps**.
* **Describe the current behavior** and **explain which behavior you expected to see instead** and why.
* **Explain why this enhancement would be useful** to most users.

### Pull Requests

1. Fork the repo and create your branch from `main`.
2. If you've added code that should be tested, add tests.
3. If you've changed APIs, update the documentation.
4. Ensure the test suite passes.
5. Make sure your code lints.
6. Issue that pull request!

## Development Process

### Setting Up Development Environment

1. **Fork and Clone**
   ```bash
   git clone https://github.com/YourUsername/ritwik-houserobberies.git
   cd ritwik-houserobberies
   ```

2. **Install Dependencies**
   - Ensure you have a FiveM development server
   - Install QBCore framework
   - Install ox_lib
   - Install ps-ui (optional but recommended)

3. **Test Environment**
   - Set up a local test server
   - Add the resource to your server
   - Test all functionality before submitting changes

### Code Style Guidelines

#### Lua Conventions
- Use 4 spaces for indentation
- Use descriptive variable names
- Add comments for complex logic
- Follow existing code patterns in the project

#### File Organization
- Client-side code goes in `client/`
- Server-side code goes in `server/`
- Shared configuration in `config.lua`
- Documentation in root directory

#### Naming Conventions
```lua
-- Variables: camelCase
local playerPed = PlayerPedId()
local cooldownTime = 600

-- Constants: UPPER_CASE
local MAX_LOOT_ITEMS = 6
local DEFAULT_COOLDOWN = 600

-- Functions: camelCase
function checkPlayerCooldown(playerId)
    -- function body
end

-- Events: kebab-case with resource prefix
RegisterNetEvent('ritwik-houserobbery:client:enterHouse')
```

### Commit Guidelines

#### Commit Message Format
```
<type>(<scope>): <subject>

<body>

<footer>
```

#### Type
- **feat**: A new feature
- **fix**: A bug fix
- **docs**: Documentation only changes
- **style**: Changes that do not affect the meaning of the code
- **refactor**: A code change that neither fixes a bug nor adds a feature
- **perf**: A code change that improves performance
- **test**: Adding missing tests
- **chore**: Changes to the build process or auxiliary tools

#### Examples
```
feat(cooldown): add Steam ID fallback for cooldown tracking

Add license identifier as fallback when Steam ID is not available.
This ensures cooldown system works in all server configurations.

Closes #123
```

```
fix(loot): resolve variable shadowing in loot spawning

Changed loop iterator from 'k' to 'obj' to prevent overwriting
the object reference during loot spawning process.

Fixes #456
```

### Testing

Before submitting a pull request, please ensure:

1. **Functionality Testing**
   - Test all house tiers (1-4)
   - Test all minigame types
   - Test cooldown system

2. **Edge Case Testing**
   - Test with missing dependencies
   - Test with invalid configurations
   - Test server restart scenarios
   - Test player disconnect/reconnect

3. **Performance Testing**
   - Monitor server performance impact
   - Check for memory leaks
   - Verify network efficiency

### Documentation

- Update README.md if you change functionality
- Update CHANGELOG.md following the format
- Add inline comments for complex logic
- Update configuration examples if needed

## Important Notes

### Resource Name Warning
⚠️ **CRITICAL**: Never change the resource name `ritwik-houserobberies`. The system has hardcoded references that depend on this exact name.

### Breaking Changes
- Always document breaking changes in CHANGELOG.md
- Provide upgrade instructions
- Consider backward compatibility when possible

### Dependencies
- Keep dependencies to a minimum
- Use optional dependencies when possible
- Always check if dependencies exist before using them

## Recognition

Contributors will be recognized in:
- README.md credits section
- CHANGELOG.md for significant contributions
- GitHub releases notes

## Questions?

Don't hesitate to ask questions by creating an issue with the `question` label or reaching out on our Discord server.

Thank you for contributing! 🎉
