return {
  "neovim/nvim-lspconfig",
  event        = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    {
      "folke/lazydev.nvim",
      ft   = "lua",
      opts = { library = { { path = "${3rd}/luv/library", words = { "vim%.uv" } } } },
    },
  },
  config = function()
    local caps = require("cmp_nvim_lsp").default_capabilities()

    -- ── Diagnósticos ──────────────────────────────────────────────────────
    local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
    for type, icon in pairs(signs) do
      vim.fn.sign_define("DiagnosticSign"..type, {
        text = icon, texthl = "DiagnosticSign"..type, numhl = ""
      })
    end
    vim.diagnostic.config({
      virtual_text     = { prefix = "●" },
      update_in_insert = false,
      severity_sort    = true,
      float            = { border = "rounded", source = true },
    })

    -- ── Keymaps ao conectar LSP ────────────────────────────────────────────
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
      callback = function(ev)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, silent = true, desc = desc })
        end
        map("n",        "gR",          "<cmd>Telescope lsp_references<CR>",       "Referências")
        map("n",        "gD",          vim.lsp.buf.declaration,                   "Declaração")
        map("n",        "gd",          "<cmd>Telescope lsp_definitions<CR>",      "Definição")
        map("n",        "gi",          "<cmd>Telescope lsp_implementations<CR>",  "Implementação")
        map("n",        "gt",          "<cmd>Telescope lsp_type_definitions<CR>", "Tipo")
        map({"n","v"},  "<leader>ca",  vim.lsp.buf.code_action,                   "Code action")
        map("n",        "<leader>rn",  vim.lsp.buf.rename,                        "Rename")
        map("n",        "<leader>D",   "<cmd>Telescope diagnostics bufnr=0<CR>",  "Diagnósticos")
        map("n",        "<leader>d",   vim.diagnostic.open_float,                 "Diagnóstico float")
        map("n",        "[d",          vim.diagnostic.goto_prev,                  "Prev diagnóstico")
        map("n",        "]d",          vim.diagnostic.goto_next,                  "Next diagnóstico")
        map("i",        "<C-k>",       vim.lsp.buf.signature_help,                "Signature help")
        map("n",        "<leader>rs",  ":LspRestart<CR>",                         "Restart LSP")
      end,
    })

    -- ── Nova API: vim.lsp.config + vim.lsp.enable (lspconfig v2+) ─────────

    -- Lua
    vim.lsp.config("lua_ls", {
      capabilities = caps,
      settings = {
        Lua = {
          completion  = { callSnippet = "Replace" },
          diagnostics = { globals = { "vim", "Snacks" } },
          workspace   = { checkThirdParty = false },
          telemetry   = { enable = false },
        },
      },
    })

    -- Go
    vim.lsp.config("gopls", {
      capabilities        = caps,
      cmd                 = { "gopls" },
      filetypes           = { "go", "gomod", "gowork", "gotmpl" },
      root_markers        = { "go.work", "go.mod", ".git" },
      single_file_support = true,
      settings = {
        gopls = {
          analyses           = { unusedparams = true, shadow = true },
          staticcheck        = true,
          gofumpt            = true,
          usePlaceholders    = true,
          completeUnimported = true,
          codelenses         = { generate = true, gc_details = true, test = true, tidy = true },
          hints = {
            parameterNames         = true,
            assignVariableTypes    = true,
            compositeLiteralFields = true,
            compositeLiteralTypes  = true,
            constantValues         = true,
            functionTypeParameters = true,
            rangeVariableTypes     = true,
          },
        },
      },
    })

    -- Markdown
    vim.lsp.config("marksman", {
      capabilities = caps,
      filetypes    = { "markdown", "md", "mdx" },
    })

    -- Bash
    vim.lsp.config("bashls", {
      capabilities = caps,
      filetypes    = { "sh", "bash", "zsh" },
    })

    -- Ativa todos os servidores configurados acima
    vim.lsp.enable({ "lua_ls", "gopls", "marksman", "bashls" })
  end,
}
