{ config, pkgs, ... }:

{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./secrets
    ./wireguard.nix
  ];

  # Locale
  time.timeZone = "Europe/Madrid";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_ES.UTF-8";
    LC_IDENTIFICATION = "es_ES.UTF-8";
    LC_MEASUREMENT = "es_ES.UTF-8";
    LC_MONETARY = "es_ES.UTF-8";
    LC_NAME = "es_ES.UTF-8";
    LC_NUMERIC = "es_ES.UTF-8";
    LC_PAPER = "es_ES.UTF-8";
    LC_TELEPHONE = "es_ES.UTF-8";
    LC_TIME = "es_ES.UTF-8";
  };

  # User
  users.users.lortane = {
    isNormalUser = true;
    description = "lortane";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUgSiHOxQ6LjMqNqCZuG/ERmYCyNBeX3utA25t6gNbV lortane@wes"
    ];
  };

  nix = {
    settings = {
      auto-optimise-store = true;
      download-buffer-size = 4194304;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      trusted-public-keys = [ "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4=" ];
      trusted-users = [ "lortane" ];
    };
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };

  # So I can deploy remotely (review if can be done better)
  security.sudo.wheelNeedsPassword = false;

  # Packages
  environment.systemPackages = with pkgs; [
    vim
  ];

  # Basic server configuration
  networking.hostName = "boris";

  # Static IP configuration
  networking.interfaces.eno1.ipv4.addresses = [
    {
      address = "192.168.1.135";
      prefixLength = 24;
    }
  ];
  networking.defaultGateway = "192.168.1.1";

  # Enable SSH
  services.openssh.enable = true;

  networking.wg-server = {
    enable = true;
    openFirewall = true;
    externalInterface = "eno1";
    peers = {
      "lortane@wes" = {
        publicKey = "peoJzK9MQN3rNSAcRfnVtMoB6A2sByartvYShKUCGHM=";
        allowedIP = "10.100.0.2";
      };
    };
  };

  system.stateVersion = "25.05";
}
