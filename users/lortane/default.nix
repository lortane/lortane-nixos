{
  inputs,
  nixosModules,
  pkgs,
  hostHomeModules ? [ ],
  ...
}:

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
      modules = [ ./home ] ++ hostHomeModules;
    };
  };
in
[
  userSpecificModule
  nixosModules.normal-users
  inputs.home-manager.nixosModules.home-manager
]
