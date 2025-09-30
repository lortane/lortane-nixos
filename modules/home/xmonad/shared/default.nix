{ pkgs, lib, ... }:

let
  packages = with pkgs; [
    any-nix-shell # fish support for nix shell
    audacious # simple music player
    bazecor # configuration software for the dygma defy keyboard
    bottom # alternative to htop & ytop
    dig # dns command-line tool
    docker-compose # docker manager
    duf # disk usage/free utility
    eza # a better `ls`
    fd # "find" for files
    gimp # gnu image manipulation program
    hyperfine # command-line benchmarking tool
    insomnia # rest client with graphql support
    jmtpfs # mount mtp devices
    killall # kill processes by name
    libreoffice # office suite
    lnav # log file navigator on the terminal
    ncdu # disk space info (a better du)
    nitch # minimal system information fetch
    nix-output-monitor # nom: monitor nix commands
    nix-search # faster nix search client
    nyancat # the famous rainbow cat!
    ranger # terminal file explorer
    ripgrep # fast grep
    spotify # music player
    tdesktop # telegram messaging client
    tree # display files in a tree view
    unzip # uncompress files
    vlc # media player
    xsel # clipboard support (also for neovim)
    zip # compress files
  ];
in
{
  imports = lib.concatMap import [
    ../modules
    ../scripts
    ../themes
    # ./programs.nix
    # ./services.nix
  ];
}
