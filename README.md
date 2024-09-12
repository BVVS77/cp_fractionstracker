.## cp_fractionsTracker - Vehicle Tracking Script for FiveM

This repository contains the `cp_fractionsTracker` script, a FiveM resource developed by the CodePeak DEVELOPMENT TEAM. It allows law enforcement and other factions to track vehicles equipped with transmitters. The script integrates with **ox_target** for interaction with vehicles and utilizes the **ESX** framework for server-client communication, providing real-time blip updates on tracked vehicles.

### Features
- Automatically track vehicles equipped with transmitters for specific factions (e.g., LSPD, LSSD).
- Create and update blips in real-time for faction vehicles on the map.
- Remove blips when vehicles leave the area or are no longer tracked.
- Configurable refresh rate for updating blips and tracking vehicles.
- Integrated with **ox_target** for seamless vehicle interactions.
- Full support for **ESX** framework.

### Prerequisites
To use this script, you need the following:

- FiveM server
- **ESX** Framework
- **ox_target** (optional for interaction)
- **ox_inventory** (optional for managing transmitters)

### Installation
1. Download the repository and place it in your server's `resources` folder.
2. Add the following line to your `server.cfg`:
   ```
   start cp_fractionstracker
   ```

### Configuration
- Adjust the tracking settings in the configuration file, including faction vehicle lists, refresh rates, and blip options.
- Customize blip color, size, and name according to your needs.

### Feedback and Support
Join our **DISCORD** community for feedback, support, and updates: [CodePeak Discord](https://discord.gg/SvbGD9dkKJ)
