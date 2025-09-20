{ outputs, config, ... }:

{
  imports = [
    outputs.homeModules.nixvim
  ];

  programs.nixvim.enable = true;
}
