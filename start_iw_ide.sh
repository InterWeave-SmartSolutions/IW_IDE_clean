#!/bin/bash

# InterWeave IDE Startup Script for Wine
# This script sets up the environment and launches the IDE

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

# Get the directory where this script is located
IW_IDE_HOME="$(dirname "$(readlink -f "$0")")"
export IW_IDE_HOME

# Set Wine prefix
export WINEPREFIX="${WINEPREFIX:-$HOME/.wine_iw_ide}"

# Default workspace location
DEFAULT_WORKSPACE="$HOME/IW_IDE_Workspace"

print_status "Starting InterWeave IDE..."
print_status "IDE Home: $IW_IDE_HOME"
print_status "Wine Prefix: $WINEPREFIX"

# Check if Wine is installed
if ! command -v wine &> /dev/null; then
    print_error "Wine is not installed. Please install Wine first:"
    echo "  sudo apt install wine-stable"
    exit 1
fi

# Check if Wine prefix exists
if [ ! -d "$WINEPREFIX" ]; then
    print_warning "Wine prefix not found at $WINEPREFIX"
    print_status "Creating Wine prefix..."
    winecfg
fi

# Check if IDE executable exists
if [ ! -f "$IW_IDE_HOME/iw_ide.exe" ]; then
    print_error "IDE executable not found at $IW_IDE_HOME/iw_ide.exe"
    exit 1
fi

# Create workspace directory if it doesn't exist
if [ ! -d "$DEFAULT_WORKSPACE" ]; then
    print_status "Creating default workspace at $DEFAULT_WORKSPACE"
    mkdir -p "$DEFAULT_WORKSPACE"
fi

# Parse command line arguments
WORKSPACE="$DEFAULT_WORKSPACE"
CLEAN_START=false
DEBUG_MODE=false
JVM_ARGS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        -data)
            WORKSPACE="$2"
            shift 2
            ;;
        -clean)
            CLEAN_START=true
            shift
            ;;
        -debug)
            DEBUG_MODE=true
            shift
            ;;
        -vmargs)
            shift
            JVM_ARGS="$*"
            break
            ;;
        -h|--help)
            echo "InterWeave IDE Startup Script"
            echo ""
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  -data <path>     Specify workspace directory"
            echo "  -clean           Clean workspace (reset)"
            echo "  -debug           Enable debug mode"
            echo "  -vmargs <args>   Pass arguments to JVM"
            echo "  -h, --help       Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0                                    # Start with default workspace"
            echo "  $0 -data ~/MyWorkspace               # Use custom workspace"
            echo "  $0 -clean                            # Clean start"
            echo "  $0 -vmargs -Xmx4096m -Xms1024m      # Increase memory"
            exit 0
            ;;
        *)
            print_warning "Unknown option: $1"
            shift
            ;;
    esac
done

print_status "Using workspace: $WORKSPACE"

# Create workspace if it doesn't exist
if [ ! -d "$WORKSPACE" ]; then
    print_status "Creating workspace directory at $WORKSPACE"
    mkdir -p "$WORKSPACE"
fi

# Change to IDE directory
cd "$IW_IDE_HOME"

# Build command arguments
CMD_ARGS=()
CMD_ARGS+=("-data" "$WORKSPACE")

if [ "$CLEAN_START" = true ]; then
    print_status "Starting with clean workspace"
    CMD_ARGS+=("-clean")
fi

if [ "$DEBUG_MODE" = true ]; then
    print_status "Debug mode enabled"
    CMD_ARGS+=("-debug" "-consolelog")
fi

if [ -n "$JVM_ARGS" ]; then
    print_status "JVM arguments: $JVM_ARGS"
    CMD_ARGS+=("-vmargs")
    # Add JVM arguments
    for arg in $JVM_ARGS; do
        CMD_ARGS+=("$arg")
    done
fi

# Set up Wine environment variables for better performance
export WINEDLLOVERRIDES="mscoree,mshtml="
export PULSE_LATENCY_MSEC=30

print_status "Launching IDE with Wine..."

# Launch the IDE
if [ "$DEBUG_MODE" = true ]; then
    # In debug mode, show output
    wine iw_ide.exe "${CMD_ARGS[@]}"
else
    # Normal mode, suppress most output
    wine iw_ide.exe "${CMD_ARGS[@]}" 2>/dev/null &
    
    # Give it a moment to start
    sleep 3
    
    # Check if process is still running
    if pgrep -f "iw_ide.exe" > /dev/null; then
        print_success "InterWeave IDE started successfully!"
        print_status "Use 'ps aux | grep iw_ide' to check process status"
    else
        print_error "IDE failed to start. Try running with -debug option for more information."
        exit 1
    fi
fi
