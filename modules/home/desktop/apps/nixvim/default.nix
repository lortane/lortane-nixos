{
  pkgs,
  inputs,
  ...
}:

let
  packages = with pkgs; [
    # Required by telescope live grep
    ripgrep
    # Required by CMP and formatters
    alejandra
    nixpkgs-fmt
    prettierd
    nixfmt-classic
    stylua
    python312Packages.flake8
    vimPlugins.vim-prettier
    python312Packages.autopep8
    yapf
    black
    isort
    hadolint
    #rubyfmt
    shfmt
    xdg-utils
  ];
in
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;

    imports = [
      ./keymaps.nix
      ./options.nix
      ./plugins/lsp.nix
      ./plugins/ui.nix
      ./plugins/cmp.nix
      ./plugins/alpha.nix
      ./plugins/lspsaga.nix
      ./plugins/lualine.nix
    ];

    extraPackages = packages;
  };
}
