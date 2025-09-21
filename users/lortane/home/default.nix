{ outputs, ... }:

{
  imports = [
    ./git.nix
    ./home.nix
    ./nixvim.nix

    outputs.homeModules.common
    outputs.homeModules.starship
    outputs.homeModules.keepassxc
  ];

  programs.keepassxc = {
    dbFile = "$HOME/Nextcloud/Passwords.kdbx";
  };
}
