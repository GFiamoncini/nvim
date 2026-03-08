return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = {
        go       = { "goimports", "gofumpt" },   -- imports + formatação Go
        lua      = { "stylua" },
        sh       = { "shfmt" },
        markdown = { "prettier" },
      },
      format_on_save = {
        lsp_fallback = true,
        async        = false,
        timeout_ms   = 1500,
      },
    })

    -- <leader>mf = format (mf de "make format")
    vim.keymap.set({ "n", "v" }, "<leader>mf", function()
      conform.format({
        lsp_fallback = true,
        async        = false,
        timeout_ms   = 1500,
      })
    end, { desc = "Formatar arquivo / seleção" })
  end,
}
