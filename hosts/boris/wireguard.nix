{ config, nixosModules, ... }:

{
  imports = [ nixosModules.wg-server ];

  networking.wg-server = {
    enable = true;
    serverAddress = "10.0.0.1";
    port = 51820;
    openFirewall = true;
    externalInterface = "eno1";
    privateKeyFile = config.age.secrets."wg-server".path;
    peers = {
      "lortane@zack" = {
        publicKey = "S8/i6oFwD8tuSXSGwlBtrJ2nFxyAEbYOOZTlE3b+RSA=";
        allowedIP = "10.0.0.2";
      };
      "lortane@jack" = {
        publicKey = "KtTsHnQo5/DWo15LEtPInNeTQ+LDPWJrznCHciSy7Gw=";
        allowedIP = "10.0.0.3";
      };
      "lortane@meg" = {
        publicKey = "############################################";
        allowedIP = "10.0.0.4";
      };
    };
  };
}
