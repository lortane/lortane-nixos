{ config, ... }:

{
  nix = {
    # Disable nix channels. Use flakes instead.
    channel.enable = false;

    # De-duplicate store paths using hardlinks
    optimise.automatic = true;

    # Auto run garbage collection once a week
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };

    settings = {
      # Avoid disk full issues
      min-free = (512 * 1024 * 1024);
      max-free = (2048 * 1024 * 1024);

      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";

      # Avoid copying unnecessary stuff over SSH
      builders-use-substitutes = true;

      # Workaround for https://github.com/NixOS/nix/issues/9574
      nix-path = config.nix.nixPath;

      download-buffer-size = 524288000; # 500 MiB

      # Add all wheel users to the trusted-users group
      trusted-users = [
        "@wheel"
      ];

      # Binary caches
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
  };
}
