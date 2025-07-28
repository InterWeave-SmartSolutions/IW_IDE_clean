# IW_IDE Configuration Files

This directory contains all configuration files for the IW_IDE development environment. The files have been organized for better maintainability and Wine compatibility.

## Directory Structure

### `eclipse/`
Contains Eclipse IDE configuration files moved from the original `configuration/` directory.

- **`config.ini`** - Main Eclipse configuration file containing workspace location, osgi bundles, and runtime settings
- **`org.eclipse.osgi/`** - OSGi framework configuration and bundle state information
  - `.bundledata.*` - Bundle metadata and dependency information
  - `.state.*` - OSGi framework state files
  - `.lazy.*` - Lazy loading configuration for bundles
  - `bundles/` - Individual bundle configurations and native libraries
- **`org.eclipse.core.runtime/`** - Eclipse core runtime configuration
- **`org.eclipse.update/`** - Update manager configuration and history
  - `platform.xml` - Platform configuration descriptor
  - `history/` - Update history XML files
- **Log files** (`*.log`) - Eclipse startup and runtime logs

### `plugins/`
Contains plugin-specific configuration files.

- **`iw_sdk_1.0.0/`** - IW SDK plugin configuration
  - `im/config.xml` - Integration Manager configuration
  - `ts/config.xml` - Transaction Server configuration  
  - `project.properties` - Project-level properties
- **`plugin.properties`** - Plugin properties file
- **`plugin.xml`** - Plugin descriptor and extension points

### Root Configuration Files

- **`.eclipseproduct`** - Eclipse product identification file containing product name, version, and application information

## Legacy Path Support

Symbolic links have been created to maintain compatibility with existing applications:

- `/home/andrewwork/IW_IDE/configuration` → `/home/andrewwork/IW_IDE/config/eclipse`
- `/home/andrewwork/IW_IDE/.eclipseproduct` → `/home/andrewwork/IW_IDE/config/.eclipseproduct`

## Wine Compatibility

All configuration files have been set with appropriate permissions (755) to ensure Wine can read and write to them properly. This includes:

- Read/write access for configuration updates
- Execute permissions for directories
- Proper ownership maintained for andrewwork user

## File Modifications

When modifying configuration files:

1. **Always backup** the original configuration before making changes
2. **Test changes** in a development environment first
3. **Update symbolic links** if moving files to new locations
4. **Verify Wine access** after permission changes
5. **Document changes** in this README file

## Common Configuration Tasks

### Changing Workspace Location
Edit `eclipse/config.ini` and modify the `osgi.instance.area` property.

### Plugin Configuration
Plugin-specific settings are stored in `plugins/iw_sdk_1.0.0/configuration/`.

### Update Settings
Update manager configuration is in `eclipse/org.eclipse.update/platform.xml`.

## Troubleshooting

- If Eclipse fails to start, check the log files in `eclipse/` directory
- For Wine-related issues, verify file permissions are set correctly
- Missing symbolic links can cause "configuration not found" errors
- Bundle loading issues are often logged in the OSGi configuration files
