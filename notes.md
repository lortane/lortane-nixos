##TODO

###Hosts
    - Create Ben host (VM)

###Modules
    - Create window-manager module. Include an option for X11 for Ben

###Users
    - Create lortane user
    - Create host specific configurations for lortane

###Future features
    - nixvim: neovim config
    - stylix: theme management

The circular dependency happens because:
    outputs depends on nixosConfigurations
    nixosConfigurations depend on host configurations
    Host configurations depend on user configurations
    User configurations depend on outputs.nixosModules
    outputs.nixosModules is part of outputs - creating the circle