{
  config,
  pkgs,
  lib,
  ...
}: let
  tuigreet = pkgs.tuigreet;
  i3bin = "${pkgs.i3}/bin/i3";
  dbusRun = "${pkgs.dbus}/bin/dbus-run-session";
in {
  config = {
    # ensure runtime pieces are available system-wide
    environment.systemPackages = with pkgs; [
      # greetd/tuigreet dependencies and useful X pieces
      tuigreet
      dbus
      xorg.xorgserver
      xorg.xinit
      xorg.xauth
      i3
    ];

    # Create the X11 session wrapper script that greetd/tuigreet will run
    environment.etc."greetd/sessions/i3-x11.sh".text = lib.trimString ''
      #!/bin/sh
      # /etc/greetd/sessions/i3-x11.sh - run i3 as an X11 session with a session dbus

      # tell apps and toolkits this is an X11 session
      export XDG_SESSION_TYPE=x11

      # ensure we run i3 under a per-session DBus (notifications, systemd user units, etc.)
      exec ${dbusRun} -- ${i3bin}
    '';
    environment.etc."greetd/sessions/i3-x11.sh".mode = "0755";

    # Desktop entry that greetd/tuigreet will show. Keep Type=Application.
    environment.etc."greetd/sessions/i3.desktop".text = lib.trimString ''
      [Desktop Entry]
      Name=i3 (X11)
      Exec=/etc/greetd/sessions/i3-x11.sh
      Type=Application
      NoTerminal=true
    '';
    environment.etc."greetd/sessions/i3.desktop".mode = "0644";

    # Enable greetd and configure it to use tuigreet and our sessions directory.
    services.greetd = {
      enable = true;
      # instruct tuigreet to use /etc/greetd/sessions (where we placed the files)
      settings.default_session.command = "${tuigreet}/bin/tuigreet --sessions /etc/greetd/sessions";

      terminal = {vt = 1;};
    };

    # Optional: safer defaults for X permissions (use if you get access errors)
    # Allow seat/session management handled by greetd - do not enable a DM like sddm/xdm
    # (No change here; just note.)
  };
}
