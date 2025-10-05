{ config, nixosModules, ... }:

{
  imports = [ nixosModules.wg-server ];

  networking.wg-server = {
    enable = true;
    openFirewall = true;
    externalInterface = "eno1";
    privateKeyFile = config.age.secrets."wg-server".path;
    peers = {
      "lortane@zack" = {
        publicKey = "S8/i6oFwD8tuSXSGwlBtrJ2nFxyAEbYOOZTlE3b+RSA=";
        allowedIP = "10.100.0.2";
      };
    };
  };
}
