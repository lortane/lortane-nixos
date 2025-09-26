{
  description = "lortane's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    hypr-contrib.url = "github:hyprwm/contrib";
    hypr-contrib.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      ...
    }@inputs:
    let
      nixosModules = import ./modules/nixos;
      homeModules = import ./modules/home;

      supportedSystems = [ "x86_64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      #packages = forAllSystems (system: import ./pkgs nixpkgs.legacyPackages.${system});
      #overlays = import ./overlays { inherit inputs; };

      homeConfigurations = { };

      nixosConfigurations = {
        boris = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixosModules homeModules;
          };
          modules = [ ./hosts/boris ];
        };
        jack = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixosModules homeModules;
          };
          modules = [ ./hosts/jack ];
        };
        wes = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixosModules homeModules;
          };
          modules = [ ./hosts/wes ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          specialArgs = {
            inherit inputs nixosModules homeModules;
          };
          modules = [ ./hosts/wsl ];
        };
      };

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          flakePkgs = self.packages.${system};
        in
        {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              nixfmt-rfc-style.enable = true;
            };
          };
          build-packages = pkgs.linkFarm "flake-packages-${system}" flakePkgs;
          # deploy-checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
        }
      );
    };
}
