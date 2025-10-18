{lib, ...}: {
  plugins.conform-nvim = {
    enable = true;
    settings = {
      format_on_save = {
        lsp_fallback = "fallback";
        timeout_ms = 500;
      };
      notify_on_error = true;

      formatters_by_ft = {
        cpp = ["clang-format"];
        c = ["clang-format"];
        #lua = ["stylua"];
        nix = ["alejandra"];
      };
    };
  };

  plugins.lsp = {
    enable = true;
    inlayHints = true;
    keymaps = {
      diagnostic = {
        "<leader>E" = "open_float";
        "[" = "goto_prev";
        "]" = "goto_next";
        "<leader>do" = "setloclist";
      };
      lspBuf = {
        "K" = "hover";
        "gD" = "declaration";
        "gd" = "definition";
        "gr" = "references";
        "gI" = "implementation";
        "gy" = "type_definition";
        "<leader>ca" = "code_action";
        "<leader>cr" = "rename";
        "<leader>wl" = "list_workspace_folders";
        "<leader>wr" = "remove_workspace_folder";
        "<leader>wa" = "add_workspace_folder";
      };
    };
    preConfig = ''
      vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
        },
      })

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        {border = 'rounded'}
      )

      vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        {border = 'rounded'}
      )
    '';
    postConfig = ''
            vim.diagnostic.config({
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "✘",
            [vim.diagnostic.severity.WARN]  = "▲",
            [vim.diagnostic.severity.HINT]  = "⚑",
            [vim.diagnostic.severity.INFO]  = "",
          }
        },
        virtual_text = true,
        underline = true,
        update_in_insert = false,
      })
    '';
    servers = {
      lua_ls.enable = false; # Lua
      nil_ls.enable = true; # Nix
      clangd.enable = true; # C/C++
    };
  };

  plugins.cmp = {
    enable = true;
    settings = {
      autoEnableSources = true;
      performance = {
        debounce = 150;
      };
      sources = [
        {name = "path";}
        {
          name = "nvim_lsp";
          keywordLength = 1;
        }
        {
          name = "buffer";
          keywordLength = 3;
        }
      ];

      snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
      formatting = {
        fields = [
          "menu"
          "abbr"
          "kind"
        ];
        format = lib.mkForce ''
          function(entry, item)
            local menu_icon = {
              nvim_lsp = '[LSP]',
              luasnip = '[SNIP]',
              buffer = '[BUF]',
              path = '[PATH]',
            }

            item.menu = menu_icon[entry.source.name]
            return item
          end
        '';
      };

      mapping = lib.mkForce {
        "<Up>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        "<Down>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";

        "<C-p>" = "cmp.mapping.select_prev_item({behavior = cmp.SelectBehavior.Select})";
        "<C-n>" = "cmp.mapping.select_next_item({behavior = cmp.SelectBehavior.Select})";

        "<C-u>" = "cmp.mapping.scroll_docs(-4)";
        "<C-d>" = "cmp.mapping.scroll_docs(4)";

        "<C-e>" = "cmp.mapping.abort()";
        "<C-y>" = "cmp.mapping.confirm({select = true})";
        "<CR>" = "cmp.mapping.confirm({select = false})";

        "<C-f>" = ''
          cmp.mapping(
            function(fallback)
              if luasnip.jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';

        "<C-b>" = ''
          cmp.mapping(
            function(fallback)
              if luasnip.jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';

        "<Tab>" = ''
          cmp.mapping(
            function(fallback)
              local col = vim.fn.col('.') - 1

              if cmp.visible() then
                cmp.select_next_item(select_opts)
              elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
                fallback()
              else
                cmp.complete()
              end
            end,
            { "i", "s" }
          )
        '';

        "<S-Tab>" = ''
          cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item(select_opts)
              else
                fallback()
              end
            end,
            { "i", "s" }
          )
        '';
      };
      window = {
        completion = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          scrolloff = 0;
          colOffset = 0;
          sidePadding = 1;
          scrollbar = true;
        };
        documentation = {
          border = "rounded";
          winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:Visual,Search:None";
          zindex = 1001;
          maxHeight = 20;
        };
      };
    };
  };

  plugins.cmp-nvim-lsp.enable = true;
  plugins.cmp-buffer.enable = true;
  plugins.cmp-path.enable = true;
  plugins.cmp-treesitter.enable = true;
  plugins.dap.enable = true;
  plugins.trouble = {
    enable = true;
    settings = {};
  };
  plugins.none-ls = {
    enable = true;
    sources.formatting = {
      alejandra.enable = true;
      stylua.enable = true;
    };
  };

  plugins.lint = {
    enable = true;
    lintersByFt = {
      #lua = ["selene"];
      nix = ["alejandra"];
      cpp = ["clang-format"];
      c = ["clang-format"];
    };
  };
}
