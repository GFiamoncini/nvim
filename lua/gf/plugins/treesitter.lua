return {
  "nvim-treesitter/nvim-treesitter",
  event      = { "BufReadPre", "BufNewFile" },
  build      = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    local treesitter = require("nvim-treesitter.configs")

    treesitter.setup({
      highlight = { enable = true },
      indent    = { enable = true },

      autotag = { enable = true },

      ensure_installed = {
        -- Base
        "lua", "vim", "vimdoc", "query",
        -- Go
        "go", "gomod", "gosum", "gowork", "gotmpl",
        -- Web
        "json", "yaml", "toml",
        "html", "css",
        "svelte",
        -- Markdown
        "markdown", "markdown_inline",
        -- Infra
        "bash", "dockerfile", "gitignore",
        -- Misc
        "c", "prisma",
      },

      incremental_selection = {
        enable  = true,
        keymaps = {
          init_selection    = "<C-space>",
          node_incremental  = "<C-space>",
          scope_incremental = false,
          node_decremental  = "<bs>",
        },
      },

      -- Text objects (requer nvim-treesitter-textobjects)
      textobjects = {
        select = {
          enable    = true,
          lookahead = true,
          keymaps   = {
            ["af"] = { query = "@function.outer", desc = "ao redor da função" },
            ["if"] = { query = "@function.inner", desc = "dentro da função" },
            ["ac"] = { query = "@class.outer",    desc = "ao redor da classe" },
            ["ic"] = { query = "@class.inner",    desc = "dentro da classe" },
            ["aa"] = { query = "@parameter.outer", desc = "ao redor do argumento" },
            ["ia"] = { query = "@parameter.inner", desc = "dentro do argumento" },
            ["ab"] = { query = "@block.outer",     desc = "ao redor do bloco" },
            ["ib"] = { query = "@block.inner",     desc = "dentro do bloco" },
          },
        },
        move = {
          enable              = true,
          set_jumps           = true,
          goto_next_start     = {
            ["]f"] = { query = "@function.outer", desc = "Próxima função" },
            ["]c"] = { query = "@class.outer",    desc = "Próxima classe" },
          },
          goto_previous_start = {
            ["[f"] = { query = "@function.outer", desc = "Função anterior" },
            ["[c"] = { query = "@class.outer",    desc = "Classe anterior" },
          },
        },
        swap = {
          enable               = true,
          swap_next            = { ["<leader>sn"] = "@parameter.inner" },
          swap_previous        = { ["<leader>sp"] = "@parameter.inner" },
        },
      },
    })
  end,
}
