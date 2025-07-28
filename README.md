# InterWeave IDE (IW_IDE) - Wine Setup Guide

The InterWeave IDE is a specialized development environment for working with Creatio BPM platform and related InterWeave solutions. This repository contains a clean, portable version of the IDE designed to run on Linux systems using Wine.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Configuration](#configuration)
- [Running the IDE](#running-the-ide)
- [Troubleshooting](#troubleshooting)
- [Project Structure](#project-structure)
- [Wine Configuration](#wine-configuration)
- [Git LFS Information](#git-lfs-information)
- [Known Issues](#known-issues)

## Prerequisites

### System Requirements

- **Operating System**: Ubuntu 20.04+ or compatible Linux distribution
- **Memory**: Minimum 4GB RAM, 8GB+ recommended
- **Storage**: At least 2GB free space
- **Architecture**: x86_64 (64-bit)

### Required Packages

Install the following packages on your Ubuntu system:

```bash
# Update package list
sudo apt update

# Install Wine
sudo apt install wine-stable winetricks

# Install additional dependencies
sudo apt install wget curl unzip git

# Install Java (if not already installed)
sudo apt install openjdk-11-jdk

# Install fonts and libraries for better Windows application support
sudo apt install fonts-liberation fonts-wine
```

## Installation

### Step 1: Clone the Repository

```bash
git clone https://github.com/InterWeave-SmartSolutions/IW_IDE_clean.git
cd IW_IDE_clean
```

### Step 2: Initialize Wine Environment

Create a dedicated Wine prefix for the IDE:

```bash
# Create Wine prefix
export WINEPREFIX=~/.wine_iw_ide
winecfg
```

In the Wine configuration window:
1. Set Windows version to "Windows 10"
2. Go to "Graphics" tab and set DPI to 120
3. Click "OK"

### Step 3: Install Wine Dependencies

```bash
# Set Wine prefix
export WINEPREFIX=~/.wine_iw_ide

# Install essential Windows components
winetricks vcrun2019 dotnet48 corefonts

# Install additional libraries if needed
winetricks msxml6 vcrun2015
```

### Step 4: Set Environment Variables

Add to your `~/.bashrc` or `~/.zshrc`:

```bash
# IW_IDE Wine Configuration
export WINEPREFIX=~/.wine_iw_ide
export IW_IDE_HOME=/path/to/IW_IDE_clean
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64

# Add to PATH
export PATH=$IW_IDE_HOME:$PATH
```

Reload your shell configuration:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

## Configuration

### Java Configuration

Ensure Java is properly configured for Wine:

```bash
# Check Java installation
java -version

# If Java is not found in Wine, you may need to install it in Wine prefix
export WINEPREFIX=~/.wine_iw_ide
wine /path/to/jdk-installer.exe  # if needed
```

### IDE Configuration Files

The IDE uses several configuration files:

1. **`iw_ide.ini`** - Main IDE configuration
2. **`config/eclipse/config.ini`** - Eclipse-based configuration
3. **`config/.eclipseproduct`** - Product identification

### Workspace Setup

Create a workspace directory:

```bash
mkdir -p ~/IW_IDE_Workspace
```

## Running the IDE

### Basic Startup

```bash
cd /path/to/IW_IDE_clean
export WINEPREFIX=~/.wine_iw_ide
wine iw_ide.exe
```

### Startup Script

Create a convenient startup script (`start_iw_ide.sh`):

```bash
#!/bin/bash
export WINEPREFIX=~/.wine_iw_ide
export IW_IDE_HOME="$(dirname "$(readlink -f "$0")")"

cd "$IW_IDE_HOME"
wine iw_ide.exe -data ~/IW_IDE_Workspace "$@"
```

Make it executable:
```bash
chmod +x start_iw_ide.sh
```

### Command Line Options

The IDE supports various command-line options:

```bash
# Specify workspace
wine iw_ide.exe -data /path/to/workspace

# Clean workspace (reset)
wine iw_ide.exe -clean

# Debug mode
wine iw_ide.exe -debug

# Specify JVM options
wine iw_ide.exe -vmargs -Xmx2048m -Xms512m
```

## Wine Configuration

### Optimal Wine Settings

For best performance, configure Wine with:

```bash
export WINEPREFIX=~/.wine_iw_ide
winecfg
```

**Recommended settings:**
- **Applications**: Windows 10
- **Graphics**: 
  - DPI: 120
  - Allow window manager to decorate windows: Checked
- **Audio**: PulseAudio (usually default)

### Registry Tweaks

Some useful Wine registry modifications:

```bash
# Improve font rendering
wine regedit
# Navigate to HKEY_CURRENT_USER\Control Panel\Desktop
# Set "FontSmoothing" to "2"
# Set "FontSmoothingType" to "2"
```

### Performance Tuning

For better performance:

```bash
# Enable CSMT (Command Stream Multi-Threading)
export WINEPREFIX=~/.wine_iw_ide
winecfg
# Graphics tab -> Enable "Enable CSMT"

# Reduce audio latency
export PULSE_LATENCY_MSEC=30
```

## Troubleshooting

### Common Issues and Solutions

#### 1. IDE Won't Start

**Problem**: IDE executable doesn't launch or crashes immediately.

**Solutions**:
```bash
# Check Wine prefix
export WINEPREFIX=~/.wine_iw_ide
winecfg

# Reinstall Visual C++ Runtime
winetricks vcrun2019

# Check for missing DLLs
wine iw_ide.exe 2>&1 | grep -i "dll"
```

#### 2. Font Rendering Issues

**Problem**: Text appears corrupted or unreadable.

**Solutions**:
```bash
# Install additional fonts
winetricks corefonts liberation

# Install Windows fonts (if available)
winetricks fontfix
```

#### 3. Java/JRE Issues

**Problem**: IDE can't find Java runtime.

**Solutions**:
```bash
# Check Java in Wine
export WINEPREFIX=~/.wine_iw_ide
wine java -version

# Point to system Java
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
```

#### 4. Performance Issues

**Problem**: IDE runs slowly or freezes.

**Solutions**:
```bash
# Increase memory allocation
wine iw_ide.exe -vmargs -Xmx4096m -Xms1024m

# Use faster graphics mode
export WINEPREFIX=~/.wine_iw_ide
winecfg  # Set graphics to "Emulate a virtual desktop"
```

### Debug Mode

To run in debug mode and see detailed error messages:

```bash
export WINEPREFIX=~/.wine_iw_ide
export WINEDEBUG=+all  # Very verbose, use sparingly
wine iw_ide.exe -debug -consolelog
```

### Log Files

Check these locations for log files:
- `~/.wine_iw_ide/drive_c/users/$USER/Temp/`
- `./workspace/.metadata/.log`
- Wine debug output via `WINEDEBUG`

## Project Structure

```
IW_IDE_clean/
├── README.md                           # This file
├── iw_ide.exe                         # Main IDE executable
├── iw_ide.ini                         # IDE configuration
├── startup.jar                        # Eclipse startup JAR
├── config/                            # Configuration files
│   └── eclipse/
│       └── config.ini                 # Eclipse configuration
├── jre/                               # Java Runtime Environment
├── plugins/                           # IDE plugins
└── Documents/                         # Documentation
    ├── IWDAEMON_TROUBLESHOOTING_GUIDE.md
    ├── JRE_CONSOLIDATION_SUMMARY.md
    └── ORGANIZATION_SUMMARY.md
```

## Development Setup

### Setting up Development Environment

1. **Create Workspace**:
   ```bash
   mkdir -p ~/IW_IDE_Workspace/projects
   ```

2. **Configure IDE Settings**:
   - Go to Window → Preferences
   - Set up code formatting, compiler settings
   - Configure source control (Git/SVN)

3. **Import Projects**:
   - File → Import → Existing Projects into Workspace
   - Select your project directory

### Creatio Development

For Creatio BPM development:

1. **Configure Creatio Connection**:
   - Set up connection to Creatio instance
   - Configure authentication credentials
   - Test connection

2. **Package Development**:
   - Create new Creatio package
   - Set up package structure
   - Configure build settings

## Git LFS Information

This repository uses **Git Large File Storage (LFS)** to efficiently handle large binary files. LFS provides several benefits:

### Benefits
- **Faster Clones**: Repository downloads are much faster (~728KB vs 49MB)
- **Better Performance**: Git operations remain fast
- **Large File Support**: Handles files up to 2GB (vs 100MB Git limit)
- **Automatic Handling**: LFS files are downloaded transparently

### Files Tracked by LFS
- **JAR files**: Java archives including the large rt.jar (~61MB)
- **ZIP files**: Plugin archives and IDE tools
- **PDF files**: Documentation and user guides
- **EXE files**: IDE executable and Windows binaries
- **DLL files**: Windows dynamic libraries

### User Experience
```bash
# Cloning works exactly the same
git clone https://github.com/InterWeave-SmartSolutions/IW_IDE_clean.git

# Large files are automatically downloaded
# No special commands needed!
```

### For Contributors
If you plan to add large files:

```bash
# Install Git LFS (one time setup)
sudo apt install git-lfs
git lfs install

# Check what's tracked
git lfs track

# Add new file types if needed
git lfs track "*.newextension"
```

**📋 For complete LFS documentation, see [`GIT_LFS_SETUP.md`](GIT_LFS_SETUP.md)**

## Known Issues

### Wine-Specific Limitations

1. **Clipboard**: Copy/paste between Wine and Linux may not work perfectly
2. **File Dialogs**: May look different from native Linux dialogs
3. **Integration**: Limited integration with Linux desktop environment

### Workarounds

1. **File Access**: Use Wine's drive mapping to access Linux files:
   ```bash
   # Map Linux directory to Wine drive
   ln -s /path/to/linux/projects ~/.wine_iw_ide/drive_c/projects
   ```

2. **External Tools**: Use Linux versions when possible:
   ```bash
   # Use Linux Git instead of Windows Git
   export PATH=/usr/bin:$PATH
   ```

## Support and Documentation

### Additional Resources

- **Troubleshooting Guide**: See `IWDAEMON_TROUBLESHOOTING_GUIDE.md`
- **Organization Summary**: See `ORGANIZATION_SUMMARY.md`
- **JRE Information**: See `JRE_CONSOLIDATION_SUMMARY.md`

### Getting Help

1. Check the troubleshooting section above
2. Review Wine documentation: https://wiki.winehq.org/
3. InterWeave SmartSolutions support channels

### Contributing

To contribute improvements to this setup:

1. Fork the repository
2. Make your changes
3. Test with different Wine versions
4. Submit a pull request

## Version Information

- **Wine Version**: Tested with Wine 6.0+
- **Java Version**: OpenJDK 11
- **IDE Version**: Check `iw_ide.ini` for version information

---

**Note**: This setup guide is specific to running InterWeave IDE on Linux systems using Wine. For native Windows installation, please refer to the standard installation documentation.
