{ homeModules, ... }:

{
  imports = [
    ./git.nix
    ./home.nix
    ./nixvim.nix

    homeModules.common
    homeModules.starship
    homeModules.keepassxc
  ];

  programs.keepassxc = {
    dbFile = "$HOME/Nextcloud/Passwords.kdbx";
  };
}
