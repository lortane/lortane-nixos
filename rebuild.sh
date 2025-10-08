#!/bin/sh

FLAKE_PATH="$HOME/.config/lortanix" # Default flake path
NIXOS_HOST="$(hostname)"         # Default hostname. Used to identify the NixOS configuration
BUILD_HOST=""                    # Default build host. Empty means localhost
TARGET_HOST=""                   # Default target host. Empty means localhost
UPDATE=0                         # Default to not update flake repositories
UPDATE_INPUTS=""                 # Default list of inputs to update. Empty means all
ROLLBACK=0                       # Default to not rollback
SHOW_TRACE=0                     # Default to not show detailed error messages

# Function to display the help message
Help() {
  echo "Wrapper script for 'nixos-rebuild switch' command."
  echo "Usage: rebuild [OPTIONS]"
  echo
  echo "Options:"
  echo "  -H, --host <host>      Specify the hostname (as in 'nixosConfiguraions.<host>'). Default: $NIXOS_HOST"
  echo "  -p, --path <path>      Set the path to the flake directory. Default: $FLAKE_PATH"
  echo "  -U, --update [inputs]  Update all flake inputs. Optionally provide comma-separated list of inputs to update instead."
  echo "  -r, --rollback         Don't build the new configuration, but use the previous generation instead"
  echo "  -t, --show-trace       Show detailed error messages"
  echo "  -B, --build-host <user@example.com>   Use a remote host for building the configuration via SSH"
  echo "  -T, --target-host <user@example.com>  Deploy the configuration to a remote host via SSH. If '--host' is specified, it will be used as the target host."
  echo "  -h, --help             Show this help message"
}

# Function to handle errors
error() {
  echo "Error: $1"
  exit 1
}

# Function to rebuild NixOS configuration
Rebuild_nixos() {
  local FLAKE="$FLAKE_PATH#$NIXOS_HOST"

  # Construct rebuild command
  CMD="nixos-rebuild switch --sudo --flake $FLAKE"
  [ "$ROLLBACK" = 1 ] && CMD="$CMD --rollback"
  [ "$SHOW_TRACE" = 1 ] && CMD="$CMD --show-trace"
  [ -n "$BUILD_HOST" ] && CMD="$CMD --build-host $BUILD_HOST"
  if [ "$NIXOS_HOST" != "$(hostname)" ] && [ -z "$TARGET_HOST" ]; then
    TARGET_HOST="$NIXOS_HOST"
    echo "Using '$TARGET_HOST' as target host."
  fi
  [ -n "$TARGET_HOST" ] && CMD="$CMD --target-host $TARGET_HOST --ask-sudo-password"

  # Rebuild NixOS configuration
  if [ "$ROLLBACK" = 0 ]; then 
    echo "Rebuilding NixOS configuration '$FLAKE'..." 
  else
    echo "Rolling back to last NixOS generation..."
  fi

  echo "Executing command: $CMD"
  $CMD || error "NixOS rebuild failed"
  echo "NixOS rebuild completed successfully."
}

# Function to Update flake repositories
Update() {
  echo "Updating flake inputs..."

  # Construct update command
  CMD="nix flake update --flake $FLAKE_PATH"
  if [ -n "$UPDATE_INPUTS" ]; then
    # Split comma-separated inputs and pass them to nix flake update
    IFS=',' read -ra INPUTS <<< "$UPDATE_INPUTS"
    for input in "${INPUTS[@]}"; do
      CMD="$CMD $input"
    done
  fi

  echo "Executing command: $CMD"
  $CMD || error "Failed to update flake repositories"
  echo "Flake repositories updated successfully."
}

# Parse command-line options
while [ $# -gt 0 ]; do
  case "$1" in
    -h|--help)
      Help
      exit 0
      ;;
    -H|--host)
      if [ -n "$2" ]; then
        NIXOS_HOST="$2"
        shift 2
      else
        error "-H|--host option requires an argument"
      fi
      ;;
    -p|--path)
      if [ -n "$2" ]; then
        FLAKE_PATH="$2"
        shift 2
      else
        error "-p|--path option requires an argument"
      fi
      ;;
    -U|--update)
      UPDATE=1
      # Check if next argument is a non-option
      if [ $# -gt 1 ] && [ "${2#-}" = "$2" ]; then
        UPDATE_INPUTS="$2"
        shift 2
      else
        shift
      fi
      ;;
    -r|--rollback)
      ROLLBACK=1
      shift
      ;;
    -t|--show-trace)
      SHOW_TRACE=1
      shift
      ;;
    -B|--build-host)
      if [ -n "$2" ]; then
        BUILD_HOST="$2"
        shift 2
      else
        error "-B|--build-host option requires an argument"
      fi
      ;;
    -T|--target-host)
      if [ -n "$2" ]; then
        TARGET_HOST="$2"
        shift 2
      else
        error "-T|--target-host option requires an argument"
      fi
      ;;
    *)
      echo "Error: Unknown option '$1'"
      Help
      exit 1
      ;;
  esac
done

# Check if script is run with sudo
if [ "$EUID" -eq 0 ]; then
  error "Do not run this script with sudo."
fi

# Check if flake path exists
if [ ! -d "$FLAKE_PATH" ]; then
  error "Flake path '$FLAKE_PATH' does not exist"
fi

# Ignore trailing slash in flake path
FLAKE_PATH="${FLAKE_PATH%/}"

# Check if flake.nix exists
if [ ! -f "$FLAKE_PATH/flake.nix" ]; then
  error "flake.nix does not exist in '$FLAKE_PATH'"
fi

# Execute updates and rebuilds based on the command
[ "$UPDATE" = 1 ] && Update

# Always rebuild NixOS by default
Rebuild_nixos