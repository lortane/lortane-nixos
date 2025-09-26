{
  inputs,
  nixosModules,
  hostHomeModules ? [ ],
  ...
}:

let
  userSpecificModule = {
    normalUsers = {
      lortane = {
        extraGroups = [
          "wheel"
        ];
        sshKeyFiles = (import ./keys.nix).keyPaths;
      };
    };

    home-manager.users."lortane" = {
      imports = [ ./home ] ++ hostHomeModules;
    };
  };
in
[
  userSpecificModule
  nixosModules.normal-users
  inputs.home-manager.nixosModules.home-manager
]
