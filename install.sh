#!/usr/bin/env bash
set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

die() { echo -e "${RED}Error: $1${NC}" >&2; exit 1; }
info() { echo -e "${BLUE}$1${NC}"; }
success() { echo -e "${GREEN}$1${NC}"; }
warn() { echo -e "${YELLOW}$1${NC}"; }

confirm() {
    read -rp "$1 [y/N]: " answer
    [[ "$answer" =~ ^[Yy]$ ]] || exit 0
}

check_root() {
    if [[ "$EUID" -eq 0 ]]; then
      die "Don't run as root. nixos-rebuild will ask for sudo when needed."
    fi
}

get_host() {
    echo "Choose host:"
    echo "  [B]oris"
    echo "  [J]ack"
    
    while true; do
        read -rp "Enter choice: " choice
        case "${choice,,}" in
            b) HOST="boris"; break ;;
            j) HOST="jack"; break ;;
            *) echo "Invalid choice, try again." ;;
        esac
    done
    info "Selected host: $HOST"
}

apply_configuration() {
    local config_path="hosts/$HOST/hardware.nix"
    info "Copying hardware configuration..."
    
    if [[ -f "/etc/nixos/hardware-configuration.nix" ]]; then
        cp "/etc/nixos/hardware-configuration.nix" "$config_path"
    else
        warn "Hardware config not found at /etc/nixos/hardware-configuration.nix"
        confirm "Continue without hardware configuration?"
    fi
}

build_system() {
    confirm "Build system for $HOST?"
    info "Running: sudo nixos-rebuild switch --flake .#$HOST"
    
    if sudo nixos-rebuild switch --flake ".#$HOST"; then
        success "System build successful! Welcome to NixOS!"
    else
        die "Build failed. Check errors above."
    fi
}

main() {
    check_root
    info "=== NixOS Flake Installer ==="
    warn "This will modify system configuration files."
    
    get_host
    apply_configuration
    build_system
}

main "$@"
