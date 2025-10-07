{
  description = "lortane's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    agenix-rekey.url = "github:oddlama/agenix-rekey";
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";

    hypr-contrib.url = "github:hyprwm/contrib";
    hypr-contrib.inputs.nixpkgs.follows = "nixpkgs";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";

    spicetify-nix.url = "github:gerg-l/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    stylix.url = "github:nix-community/stylix";
    stylix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      agenix-rekey,
      home-manager,
      nixos-generators,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };

      homeModules = import ./modules/home;
      nixosModules = import ./modules/nixos;

      # Helper function to create NixOS configurations
      mkNixOSConfig =
        hostPath:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs homeModules nixosModules;
          };
          modules = [ hostPath ];
        };
    in
    {
      packages.x86_64-linux = {
        vmware = nixos-generators.nixosGenerate {
          system = "x86_64-linux";
          modules = [ ./hosts/wes ];
          specialArgs = {
            inherit inputs homeModules nixosModules;
            isImage = true;
          };
          format = "vmware";
        };
      };

      nixosConfigurations = {
        boris = mkNixOSConfig ./hosts/boris;
        jack = mkNixOSConfig ./hosts/jack;
        wes = mkNixOSConfig ./hosts/wes;
        wsl = mkNixOSConfig ./hosts/wsl;
      };

      agenix-rekey = agenix-rekey.configure {
        userFlake = self;
        nixosConfigurations = self.nixosConfigurations;
      };
    };
}
