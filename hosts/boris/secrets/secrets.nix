let
  keys = import ../../../users/lortane/keys.nix;
  lortaneKeys = keys.keyStrings;
  boris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOCXP3qTpwHZ9j6Isc68kT/2nUGbFPxfYcOPei61Thz";
in {
  "wg-server.age".publicKeys = [boris] ++ lortaneKeys;
  "cloudflare-api.age".publicKeys = [boris] ++ lortaneKeys;
}
