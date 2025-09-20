{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.wayland.windowManager.hyprland;
  apps = cfg.applications;

  # dynamically create a set of default app assignments
  defaultApps = mapAttrs (name: app: app.default) apps;

  # function to generate the attribute set for each application
  mkAppAttrs =
    {
      default,
      bind ? [ "" ],
      windowrule ? [ "" ],
    }:
    {
      default = mkOption {
        type = types.str;
        default = default;
        description = "The default application to use for the ${default}.";
      };
      bind = mkOption {
        type = types.listOf types.str;
        default = bind;
        description = "The keybinding to use for the ${default}.";
      };
      windowrule = mkOption {
        type = types.listOf types.str;
        default = windowrule;
        description = "The window rule to use for the ${default}.";
      };
    };

  # generate lists of all binds and window rules and remove empty strings
  binds = filter (s: s != "") (
    builtins.concatLists (map (app: app.bind or [ "" ]) (attrValues apps))
  );
  windowrules = filter (s: s != "") (
    builtins.concatLists (map (app: app.windowrule or [ "" ]) (attrValues apps))
  );

  inherit (lib)
    attrValues
    filter
    getExe
    mapAttrs
    mkOption
    types
    ;
in
{
  imports = [
    ./feh
    ./libreoffice
    ./librewolf
    ./mpv
    ./screenshot
    ./wezterm
    ./yazi
  ];

  options.wayland.windowManager.hyprland.applications = with defaultApps; {
    # applauncher = mkAppAttrs {
    #   default = "bemenu";
    #   bind = [ "$mod, d, exec, ${applauncher}-run" ];
    # };

    audiomixer = mkAppAttrs {
      default = "pulsemixer";
      bind = [ "$mod, a, exec, ${terminal} -T ${audiomixer} -e ${pkgs.pulsemixer}/bin/pulsemixer" ];
      windowrule = [
        "float, title:^${audiomixer}$"
        "size 50% 50%, title:^${audiomixer}$"
      ];
    };

    browser = mkAppAttrs {
      default = "librewolf";
      bind = [ "$mod, b, exec, ${browser}" ];
    };

    calculator = mkAppAttrs {
      default = "sage";
      bind = [
        ", XF86Calculator, exec, ${terminal} -T ${calculator} -e ${pkgs.sageWithDoc}/bin/sage"
      ];
    };

    equalizer = mkAppAttrs {
      default = "easyeffects";
      bind = [ "$mod CTRL, e, exec, ${getExe pkgs.easyeffects}" ];
    };

    filemanager = mkAppAttrs {
      default = "yazi";
      bind = [ "$mod, e, exec, ${terminal} -T ${filemanager} -e ${filemanager}" ];
    };

    musicplayer = mkAppAttrs {
      default = "ncmpcpp";
      bind = [ "$mod SHIFT, m, exec, ${terminal} -T ${musicplayer} -e ${musicplayer}" ];
    };

    office = mkAppAttrs {
      default = "libreoffice";
      bind = [ "$mod SHIFT, o, exec, ${office}" ];
    };

    imageviewer = mkAppAttrs { default = "feh"; };

    screenshotter = mkAppAttrs {
      default = "screenshot";
      bind = [
        "$mod,       Print, exec, ${screenshotter} output" # select monitor
        "$mod SHIFT, Print, exec, ${screenshotter} region" # select region
        "$mod CTRL,  Print, exec, ${screenshotter} window" # select window
      ];
    };

    terminal = mkAppAttrs {
      default = "wezterm";
      bind = [ "$mod, Return, exec, ${terminal}" ];
    };

    videoplayer = mkAppAttrs { default = "mpv"; };
  };

  config = {
    wayland.windowManager.hyprland.settings = {
      bind = binds;
      windowrule = windowrules;
    };
  };
}
