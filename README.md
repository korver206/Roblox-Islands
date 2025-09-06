# Islands Comprehensive Script

A Roblox script for duplicating items and adding coins in Islands game with comprehensive remote event detection.

## Features

- Duplicate items with server-side persistence
- Add coins/coins/money to your account
- Comprehensive remote event detection in multiple locations
- Debug mode for troubleshooting
- Scan functions to identify game-specific elements

## Setup Instructions

1. Create a new GitHub repository named "IslandsScript"
2. Upload the `main.lua` file to the repository
3. Get the raw URL of the file (click on the file, then click "Raw" button)
4. The raw URL will look like: `https://raw.githubusercontent.com/yourusername/IslandsScript/main/main.lua`

## Usage

To use this script in Roblox:

1. Copy the following loadstring:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/yourusername/IslandsScript/main/main.lua"))()
```

2. Replace `yourusername` with your actual GitHub username
3. Execute the loadstring in your Roblox executor (Vega X, etc.)

## Controls

- Press 'G' key to toggle the UI
- Click "Duplicate Item" to duplicate the item you're holding
- Click "Add Coins" to add 10,000 coins/money
- Use "Toggle Debug Mode" for detailed console output
- Use "Scan All for Remotes" to find remote events in the game
- Use "Scan for Coins" to identify coin locations

## Troubleshooting

If the script says "No server event found":
1. Enable Debug Mode
2. Click "Scan All for Remotes" to search everywhere
3. Check the console output for any remote events found
4. Look for events with names related to "Duplicate", "Clone", "Item", "Coin", "Add", or "Give"

If the script says "Coins not found":
1. Click "Scan for Coins" to identify all possible coin locations
2. Check the console output for coin values
3. The script will show you exactly where coins are stored in the game