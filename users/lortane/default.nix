{
  inputs,
  outputs,
  pkgs,
  hostModules ? [ ],
  ...
}:

let
  keys = import ./keys.nix;
in
{
  imports = [
    outputs.nixosModules.normal-users

    inputs.home-manager.nixosModules.home-manager
  ];

  normalUsers = {
    lortane = {
      extraGroups = [
        "openrazer"
        "wheel"
      ];
      sshKeyFiles = keys.keyPaths;
      autoLogin = true;
      enableHyprlock = true;
    };
  };

  home-manager.users."lortane" = {
    inherit pkgs;

    modules = [ ./home ] ++ hostModules;
  };
}
