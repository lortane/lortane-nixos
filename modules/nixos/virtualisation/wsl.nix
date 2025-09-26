{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.virtualisation.wsl;
in
{
  options.virtualisation.wsl = {
    enable = mkEnableOption "Windows Subsystem for Linux (WSL)";

    defaultUser = mkOption {
      type = types.str;
      default = "nixos";
      description = "Default WSL user";
    };

    startMenuLaunchers = mkOption {
      type = types.bool;
      default = true;
      description = "Whether to enable Start menu launchers";
    };

    extraPackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = "Additional packages to install for WSL";
    };

    # WSL-specific configurations
    interoperability = {
      enable = mkOption {
        type = types.bool;
        default = true;
        description = "Enable interoperability with Windows";
      };

      appendWindowsPath = mkOption {
        type = types.bool;
        default = true;
        description = "Append Windows PATH to WSL PATH";
      };
    };
  };

  # Import the nixos-wsl module if available
  imports = optional (builtins.pathExists <nixos-wsl/modules>) <nixos-wsl/modules>;

  config = mkIf cfg.enable {
    # WSL-specific configurations
    wsl = mkIf (builtins.pathExists <nixos-wsl/modules>) {
      enable = true;
      defaultUser = cfg.defaultUser;
      startMenuLaunchers = cfg.startMenuLaunchers;
    };

    # For VSCode Server
    programs.nix-ld.enable = true;

    # System packages useful for WSL
    environment.systemPackages =
      with pkgs;
      [
        wget
        curl
        file
        wslu # Windows Subsystem for Linux Utilities
      ]
      ++ cfg.extraPackages;
  };
}
