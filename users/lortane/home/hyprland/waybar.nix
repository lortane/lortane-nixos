{
  programs.waybar.settings = {
    mainBar = {
      modules-right = [
        "custom/timer"
        "custom/newsboat"
        "network"
        "cpu"
        "memory"
        "disk"
        "pulseaudio#input"
        "pulseaudio#output"
        "battery"
        "tray"
      ];
    };
  };
}
