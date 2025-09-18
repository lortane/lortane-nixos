{ inputs, ... }:

{
  imports = [ inputs.agenix.nixosModules.default ];

  age.secrets = {
    wg-server = {
      file = ./wg-server.age;
      path = "/etc/wireguard/privatekey";
      mode = "600";
    };
    cloudflare-api.file = ./cloudflare-api.age;
  };
}
