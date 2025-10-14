{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;

  cfg = config.virtualisation.qemuHost;
in {
  options.virtualisation.qemuHost = {
    enable = mkEnableOption "QEMU virtualisation with libvirtd";
  };

  config = mkIf cfg.enable {
    users.groups.libvirtd = {};

    services.spice-vdagentd.enable = true;

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
          ovmf.packages = [ pkgs.OVMFFull.fd ];
        };
      };
      spiceUSBRedirection.enable = mkDefault true;
    };

    environment.systemPackages = with pkgs; [
      # disable docs to avoid tkinter error
      (pkgs.qemu_full.override {
        enableDocs = false;
        cephSupport = false;
      })
      dnsmasq
    ];

    systemd.tmpfiles.rules = [ "L+ /var/lib/qemu/firmware - - - - ${pkgs.qemu}/share/qemu/firmware" ];
  };
}
