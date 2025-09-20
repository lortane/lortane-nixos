{ outputs, config, ... }:

{
  imports = [
    outputs.homeModules.nixvim
  ];

  programs.nixvim = {
    enable = true;
    plugins = {
      render-markdown = {
        enable = true;
        settings = {
          file_types = [
            "Avante"
          ];
        };
      };
      which-key.enable = true;
      # cmp-nvim-ultisnips.enable = true;
    };
  };
}
