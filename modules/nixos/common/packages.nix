{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core system utilities (essential for all systems)
    file # Determine file type
    git # Version control system
    htop # Interactive process viewer
    iproute2 # Network configuration tools (ip, ss commands)
    lm_sensors # Hardware monitoring sensors
    lsof # List open files and network connections
    man-pages # System documentation
    openssl # Cryptography and SSL/TLS toolkit
    pciutils # PCI bus utilities (lspci)
    psmisc # Process utilities (killall, pstree)
    rsync # File synchronization tool
    tldr # Simplified man pages
    traceroute # Network route tracing
    tree # Directory listing in tree format
    unzip # Extract ZIP archives
    usbutils # USB device utilities (lsusb)
    vim # Text editor
    wget # File downloader
    zip # Create ZIP archives

    # Security/encryption tools
    cryptsetup # Disk encryption setup

    # Network diagnostics
    dig # DNS lookup utility
    netcat-openbsd # Network swiss army knife
  ];
}
