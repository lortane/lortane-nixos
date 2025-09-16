{ config, pkgs, ... }:

{
  services.cloudflare-dyndns = {
    enable = true;
    domains = [ "lortane.com" ];
    ipv4 = true;
    ipv6 = false;
    proxied = false;

    apiTokenFile = config.age.secrets."cloudflare-api".path;
  };
}
