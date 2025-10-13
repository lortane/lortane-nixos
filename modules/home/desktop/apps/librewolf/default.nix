{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkIf;

  cfg = config.desktop;
  shouldEnable = cfg.enable && cfg.appBundles.core;

  engines = import ./engines.nix pkgs;
  settings = import ./settings.nix;

  searchConfig = {
    force = true;
    default = "Startpage";
    privateDefault = "Startpage";
    order = ["Startpage"];
    engines =
      {
        Startpage = {
          urls = [{template = "https://www.startpage.com/do/dsearch?q={searchTerms}";}];
          icon = "https://www.startpage.com/sp/cdn/favicons/favicon--default.ico";
          updateInterval = 24 * 60 * 60 * 1000; # every day
        };
        # Additional search engines from engines.nix
        "NixOS Packages" = {
          urls = [{template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";}];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@np"];
        };
        "NixOS Options" = {
          urls = [{template = "https://search.nixos.org/options?channel=unstable&query={searchTerms}";}];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["@no"];
        };
        # Add more engines as needed from engines.nix
      }
      // (lib.genAttrs ["github" "nixos-wiki" "youtube"] (name: {
        urls = [{template = engines.${name}.url;}];
        icon = engines.${name}.icon;
        definedAliases = [engines.${name}.alias];
        updateInterval =
          if (lib.strings.match "^(http|https|ftp)://" engines.${name}.icon) != null
          then 24 * 60 * 60 * 1000
          else null;
      }));
  };
in {
  config = mkIf shouldEnable {
    programs.librewolf = {
      enable = true;
      policies.Homepage.StartPage = mkDefault "previous-session";

      profiles.default = {
        settings = settings;
        search = searchConfig;
      };
    };

    home.sessionVariables = {
      DEFAULT_BROWSER = "${pkgs.librewolf}/bin/librewolf";
      BROWSER = "${pkgs.librewolf}/bin/librewolf";
    };
  };
}
