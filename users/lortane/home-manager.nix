{
  inputs,
  homeModules,
  hostHomeModules ? [ ],
  ...
}:

{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.lortane.imports = [ ./home ] ++ hostHomeModules;
    extraSpecialArgs = {
      spicetify-nix = inputs.spicetify-nix;
      inherit homeModules;
    };
  };
}
