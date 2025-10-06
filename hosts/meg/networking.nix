{ config, nixosModules, ... }:

{
  imports = [
    nixosModules.wg-client
  ];

  networking.hostName = "meg";
  networking.useDHCP = true;

  # networking.wg-client = {
  #   enable = true;
  #   internalInterface = "wg0";
  #   clientAddress = "10.0.0.4";
  #   privateKeyFile = config.age.secrets."wg-client".path;

  #   peer = {
  #     publicKey = "8Wl+XepHkVZb1Iqbmi+vqLuMXYWiY4YhwdIb7ZwQEzs=";
  #     publicIP = "lortane.com";
  #     port = 51820;
  #     internalIP = "10.0.0.1";
  #     allowedIPs = [ "0.0.0.0/0" ];
  #   };
  # };
}
