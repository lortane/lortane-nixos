{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.virtualisation.qemuHost;
in
{
  options.virtualisation.qemuHost = {
    enable = mkEnableOption "QEMU virtualisation with libvirtd";
  };

  config = mkIf cfg.enable {
    users.groups.libvirtd = { };

    # Enable virtual manager
    programs.virt-manager.enable = mkDefault true;

    virtualisation = {
      libvirtd = {
        enable = mkDefault true;
        onBoot = mkDefault "ignore";
        onShutdown = mkDefault "shutdown";
        qemu = {
          runAsRoot = mkDefault false;
          swtpm.enable = mkDefault true;
          ovmf.enable = mkDefault true;
        };
      };
      spiceUSBRedirection.enable = mkDefault true;
    };

    environment.systemPackages = with pkgs; [
      qemu_full
      dnsmasq
    ];
  };
}
