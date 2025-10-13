let
  keys = import ../../../users/lortane/keys.nix;
  lortaneKeys = keys.keyStrings;
  jack = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBfJEMxzdLxCFBFeWKMzI9nZRUj6RRWyg98mg95TjqKE";
in {
  "wg-client.age".publicKeys = [jack] ++ lortaneKeys;
}
