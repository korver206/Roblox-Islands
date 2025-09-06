# Islands Comprehensive Script v3.0

A Roblox script for duplicating items and adding coins in Islands game with comprehensive remote event detection, caching, and item browser.

## Features

- Duplicate held items with server-side persistence
- Add coins/coins/money to your account
- Comprehensive remote event detection in multiple locations
- Caching of found events for better performance
- Game item scanner with categorized UI browser
- Debug mode for troubleshooting
- Clear event cache when needed

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
- Click "Duplicate Held Item" to duplicate the item you're holding
- Click "Add Coins" to add 10,000 coins/money
- Use "Toggle Debug Mode" for detailed console output
- Use "Scan All Remotes" to find remote events in the game
- Use "Scan Game Items" to browse and select items from the game
- Use "Clear Event Cache" to reset cached events and rescan

## Item Browser

The "Scan Game Items" button creates a categorized UI browser:
1. Shows all available items in the game
2. Allows you to select any item
3. Specify the amount you want in the textbox
4. Click on an item to receive it

## How It Works

1. **First Run**: When you first click "Duplicate Item" or "Add Coins", the script searches for the appropriate remote events
2. **Caching**: Once found, the script caches these events for faster subsequent use
3. **Scanning**: If you're having trouble, use the "Scan All Remotes" button to see all available events
4. **Item Browser**: Use "Scan Game Items" to browse all available items in the game
5. **Fallback**: If no remote events are found, the script will attempt direct value modification

## Troubleshooting

If the script says "No server event found":
1. Enable Debug Mode
2. Click "Scan All Remotes" to search everywhere
3. Check the UI output for any remote events found
4. Look for events with names related to "Duplicate", "Clone", "Item", "Coin", "Add", or "Give"

If the script says "Coins not found":
1. Click "Scan for Coins" to identify all possible coin locations
2. Check the UI output for coin values
3. The script will show you exactly where coins are stored in the game

If items aren't duplicating properly:
1. Try "Clear Event Cache" button
2. Click "Scan All Remotes" again
3. Try duplicating again

## Version History

- **v3.0**: Added item browser, improved UI display of scan results, enhanced caching system
- **v2.1**: Added caching of found events, improved scan consistency, better error handling
- **v2.0**: Initial release with comprehensive remote event detection

## Notes

This script is designed to work with most Roblox games that follow standard practices for item duplication and coin management. Some games may use obfuscation or custom networking that prevents this script from working.

The item browser scans ReplicatedStorage for Tools and Models that might be items. It's limited to a depth of 3 folders to prevent excessive scanning.
</content>
<line_count: 65