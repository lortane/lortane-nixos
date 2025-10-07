{ pkgs, inputs, ... }:

{
  environment.systemPackages = with pkgs; [
    # Core system administration
    file # Determine file type
    git # Version control system
    htop # Interactive process viewer
    iproute2 # Network configuration tools (ip, ss commands)
    lm_sensors # Hardware monitoring sensors
    lsof # List open files and network connections
    man-pages # System documentation
    pciutils # PCI bus utilities (lspci)
    psmisc # Process utilities (killall, pstree)
    usbutils # USB device utilities (lsusb)

    # Essential network tools
    openssl # Cryptography and SSL/TLS toolkit
    traceroute # Network route tracing
    dig # DNS lookup utility
    netcat-openbsd # Network swiss army knife

    # Basic file operations (system level)
    rsync # File synchronization tool
    unzip # Extract ZIP archives
    zip # Create ZIP archives

    # Documentation (system-wide)
    man-pages

    # Essential editors (for system emergencies)
    vim

    # Security/encryption tools
    cryptsetup # Disk encryption setup
    inputs.agenix.packages.${pkgs.system}.default # Agenix encryption tool
    inputs.agenix-rekey.packages.${pkgs.system}.default # Agenix encryption tool
  ];
}
