return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "WhoIsSethDaniel/mason-tool-installer.nvim",
  },
  config = function()
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local mason_tool_installer = require("mason-tool-installer")

    mason.setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    mason_lspconfig.setup({
      ensure_installed = { "lua_ls", "gopls", "bashls" },
      automatic_installation = true,
    })

    mason_tool_installer.setup({
      ensure_installed = {
        "golangci-lint",
        "gopls",
        "lua-language-server",
        "bash-language-server",
      },
      auto_update = true,
      run_on_start = true,
    })

    if mason_lspconfig.setup_handlers then
      mason_lspconfig.setup_handlers({
        function(server_name)
          require("lspconfig")[server_name].setup({
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
          })
        end,

        ["gopls"] = function()
          require("lspconfig").gopls.setup({
            cmd = { "gopls" },
            filetypes = { "go", "gomod", "gowork", "gotmpl" },
            root_dir = require("lspconfig").util.root_pattern("go.work", "go.mod", ".git"),
            capabilities = require("cmp_nvim_lsp").default_capabilities(),
            settings = {
              gopls = {
                analyses = {
                  unusedparams = true,
                },
                staticcheck = true,
                gofumpt = true,
              },
            },
          })
        end,
      })
    else
      mason_lspconfig.setup()
    end

    -- 🔄 🔥 FORÇA A REINICIALIZAÇÃO DO LSP IMEDIATAMENTE QUANDO O ARQUIVO É ABERTO
    vim.api.nvim_create_autocmd("BufReadPost", {
      pattern = "*.go",
      callback = function()
        vim.defer_fn(function()
          vim.cmd("LspRestart")
        end, 100)
      end,
    })
  end,
}
