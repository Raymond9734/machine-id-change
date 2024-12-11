
# Cursor Device ID Changer

## Overview

This Bash script allows users to modify the device ID for the Cursor editor. It's particularly useful when device IDs become locked due to frequent account switching or when you need to reset your device identification.

## Features

- 🔄 Automatically generates random device IDs
- 💾 Creates automatic backups of the original configuration file
- 🛠 Supports custom device ID input
- 🐧 Compatible with Linux systems (tested on Kali Linux)
- 🔒 Uses system-native tools for ID generation

## Requirements

- Bash shell
- OpenSSL
- uuidgen
- Cursor editor installed

## Installation

1. Download the script:
   ```bash
   wget https://raw.githubusercontent.com/your-repo/cursor-id-changer/main/change_cursor_id.sh
   ```

2. Make the script executable:
   ```bash
   chmod +x linux_change.sh 
   chmod +x macOs_change.sh
   ```

## Usage

### Basic Usage (Random ID Generation)
```bash
./linux_change.sh 
```

### Custom ID Usage
```bash
./linux_change.sh your_custom_id
```

## How It Works

1. Generates new random device IDs using:
   - OpenSSL for hex-based machine IDs
   - uuidgen for device UUIDs

2. Backs up the existing `storage.json` configuration file
   - Backup filename format: `storage.json.backup_YYYYMMDD_HHMMSS`

3. Replaces existing telemetry IDs in the configuration file:
   - `telemetry.machineId`
   - `telemetry.macMachineId`
   - `telemetry.devDeviceId`

## Configuration File Location

Default configuration file path:
```
~/.config/Cursor/User/globalStorage/storage.json
```

## Precautions

- Always close the Cursor editor before running the script
- Verify the configuration file path matches your system
- Backup your original configuration manually if needed

## Compatibility

- Tested on: Kali Linux
- Recommended for Linux systems

## Disclaimer

⚠️ **IMPORTANT**: This script is provided for educational and research purposes only. Using this script may potentially violate Cursor's terms of service. Use at your own risk and discretion.

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Your Name - [Your Email or Social Media]

Project Link: [click here](https://github.com/Raymond9734/machine-id-change.git)
```

You can now directly copy and paste this content into a README.md file. Remember to replace placeholders like `your-repo`, `your-username`, and contact information with your actual details.