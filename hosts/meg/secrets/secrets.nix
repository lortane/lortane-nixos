let
  keys = import ../../../users/lortane/keys.nix;
  lortaneKeys = keys.keyStrings;
  meg = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMpMQ4tlGG6QltIFTeuFB+yWNNKKo63hyrRH4stWkdmD";
in
{
  "wg-client.age".publicKeys = [ meg ] ++ lortaneKeys;
}
