{...}: {
  home.file.".config/awesome/user-config.lua".text = ''
    return {
      screens = {
          [1] = {
              primary = true
          },
          [2] = {
              primary = false,
              rotation = "right"  -- vertical orientation
          }
      }
    }
  '';
}
