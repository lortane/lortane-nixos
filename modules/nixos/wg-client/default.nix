# modules/nixos/wg-client/default.nix
{
  config,
  lib,
  ...
}: let
  cfg = config.networking.wg-client;

  inherit
    (lib)
    mkDefault
    mkEnableOption
    mkIf
    mkOption
    types
    ;
in {
  options.networking.wg-client = {
    enable = mkEnableOption "Enable VPN client";

    internalInterface = mkOption {
      type = types.str;
      default = "wg0";
      description = "The internal WireGuard interface name";
    };

    subnetMask = mkOption {
      type = types.ints.u8;
      default = 24;
      description = "The subnet mask for the VPN network";
    };

    clientAddress = mkOption {
      type = types.str;
      default = "10.0.0.2";
      description = "The client's IP address within the VPN subnet";
    };

    privateKeyFile = mkOption {
      type = types.path;
      description = "Path to the client's private key file";
    };

    peer = {
      publicKey = mkOption {
        type = types.str;
        description = "The public key of the peer";
      };

      publicIP = mkOption {
        type = types.str;
        description = "The public IP address of the VPN server";
      };

      port = mkOption {
        type = types.port;
        default = 51820;
        description = "The port number for the VPN server";
      };

      internalIP = mkOption {
        type = types.str;
        default = "10.0.0.1";
        description = "The internal IP address of the VPN server within the VPN subnet";
      };

      allowedIPs = mkOption {
        type = types.listOf types.str;
        default = ["0.0.0.0/0"];
        description = "IP ranges to route through the VPN";
      };
    };
  };

  config = mkIf cfg.enable {
    networking.wg-quick.interfaces."${cfg.internalInterface}" = {
      address = ["${cfg.clientAddress}/${toString cfg.subnetMask}"];
      dns = [cfg.peer.internalIP];
      privateKeyFile = cfg.privateKeyFile;

      peers = [
        {
          publicKey = cfg.peer.publicKey;
          allowedIPs = cfg.peer.allowedIPs;
          endpoint = "${cfg.peer.publicIP}:${toString cfg.peer.port}";
          persistentKeepalive = mkDefault 25;
        }
      ];
    };
  };
}
