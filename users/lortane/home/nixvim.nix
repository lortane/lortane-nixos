{ homeModules, ... }:

{
  imports = [
    homeModules.nixvim
  ];

  programs.nixvim.enable = false;
}
