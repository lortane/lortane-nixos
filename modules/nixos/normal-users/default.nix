{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.normalUsers;

  inherit (lib)
    attrNames
    genAttrs
    mkOption
    mkIf
    types
    ;
in
{
  options.normalUsers = mkOption {
    type = types.attrsOf (
      types.submodule {
        options = {
          extraGroups = mkOption {
            type = (types.listOf types.str);
            default = [ ];
            description = "Extra groups for the user";
            example = [ "wheel" ];
          };
          shell = mkOption {
            type = types.path;
            default = pkgs.zsh;
            description = "Shell for the user";
          };
          initialPassword = mkOption {
            type = types.str;
            default = "changeme";
            description = "Initial password for the user";
          };
          sshKeyFiles = mkOption {
            type = (types.listOf types.path);
            default = [ ];
            description = "SSH key files for the user";
            example = [ "/path/to/id_rsa.pub" ];
          };
          autoLogin = mkOption {
            type = types.bool;
            default = false;
            description = "Whether to automatically log in this user to the graphical session";
          };
        };
      }
    );
    default = { };
    description = "Users to create. The usernames are the attribute names.";
  };

  config =
    let
      autoLoginUser = lib.findFirst (user: cfg.${user}.autoLogin) null (attrNames cfg);
      autoLoginUserCount = lib.count (user: cfg.${user}.autoLogin) (attrNames cfg);
      hyprlockUsers = lib.filter (user: cfg.${user}.enableHyprlock) (attrNames cfg);
      hasHyprlockUsers = hyprlockUsers != [ ];
    in
    {

      # Create user groups
      users.groups = genAttrs (attrNames cfg) (userName: {
        name = userName;
      });

      # Create users
      users.users = genAttrs (attrNames cfg) (userName: {
        name = userName;
        inherit (cfg.${userName}) extraGroups shell initialPassword;

        isNormalUser = true;
        group = "${userName}";
        home = "/home/${userName}";
        openssh.authorizedKeys.keyFiles = cfg.${userName}.sshKeyFiles;
      });

      # Configure auto-login
      services.xserver.enable = true;
      services.displayManager = {
        autoLogin =
          if autoLoginUser != null then
            {
              enable = true;
              user = autoLoginUser;
            }
          else
            {
              enable = false;
            };
      };

      assertions = [
        {
          assertion = autoLoginUserCount <= 1;
          message = "Only one user can be set for autoLogin";
        }
      ];
    };

}
