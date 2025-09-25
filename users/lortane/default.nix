# users/lortane/default.nix
{ inputs, outputs, pkgs, ... }:

{ hostModules ? [] }:

let
  userSpecificModule = {
    normalUsers = {
      lortane = {
        extraGroups = [
          "openrazer"
          "wheel"
        ];
        sshKeyFiles = (import ./keys.nix).keyPaths;
        autoLogin = true;
        enableHyprlock = true;
      };
    };

    home-manager.users."lortane" = {
      inherit pkgs;
      modules = [ ./home ] ++ hostModules;
    };
  };
in
[
  userSpecificModule
  outputs.nixosModules.normal-users
  inputs.home-manager.nixosModules.home-manager
]