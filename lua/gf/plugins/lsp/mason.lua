return {
  {
    "williamboman/mason.nvim",
    cmd   = "Mason",
    build = ":MasonUpdate",
    config = function()
      require("mason").setup({
        ui = {
          border = "rounded",
          icons  = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
        },
      })
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",    -- Lua
        "gopls",     -- Go
        "bashls",    -- Shell
        "marksman",  -- Markdown
      },
      automatic_installation = true,
    },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "gopls", "golangci-lint", "goimports", "gofumpt",
        "lua-language-server", "stylua",
        "bash-language-server", "shfmt",
        "marksman",
      },
      auto_update  = false,
      run_on_start = true,
    },
  },
}
