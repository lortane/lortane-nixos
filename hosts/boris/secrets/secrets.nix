let
  boris = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOCXP3qTpwHZ9j6Isc68kT/2nUGbFPxfYcOPei61Thz";
  lortane = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDUgSiHOxQ6LjMqNqCZuG/ERmYCyNBeX3utA25t6gNbV";
in
{
  "wg-server.age".publicKeys = [
    boris
    lortane
  ];
  "cloudflare-api.age".publicKeys = [
    boris
    lortane
  ];
}
