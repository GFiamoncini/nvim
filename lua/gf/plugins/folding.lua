-- nvim-ufo: folding moderno com suporte a LSP e treesitter
-- Exibe a quantidade de linhas dobradas e permite "peek" sem abrir o fold
return {
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
    },
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      local ufo = require("ufo")

      vim.o.foldcolumn     = "1"
      vim.o.foldlevel      = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable     = true

      -- Texto customizado para folds fechados (mostra nº de linhas)
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix      = (" 󰁂 %d linhas "):format(endLnum - lnum)
        local sufWidth    = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth    = 0

        for _, chunk in ipairs(virtText) do
          local chunkText  = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText  = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, "MoreMsg" })
        return newVirtText
      end

      ufo.setup({
        provider_selector = function(bufnr, filetype, buftype)
          local ftMap = {
            go       = { "lsp", "treesitter" },
            lua      = { "treesitter" },
            markdown = { "treesitter" },
            sh       = { "treesitter" },
          }
          return ftMap[filetype] or { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
        open_fold_hl_timeout   = 400,
        close_fold_kinds_for_ft = {
          default = { "imports", "comment" },
          go      = { "imports", "comment" },
        },
        preview = {
          win_config = {
            border       = "rounded",
            winhighlight = "Normal:Folded",
            winblend     = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
      })

      -- Keymaps de folding
      vim.keymap.set("n", "zR", ufo.openAllFolds,         { desc = "Abrir todos os folds" })
      vim.keymap.set("n", "zM", ufo.closeAllFolds,        { desc = "Fechar todos os folds" })
      vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "Abrir folds (exceto imports)" })
      vim.keymap.set("n", "zm", ufo.closeFoldsWith,       { desc = "Fechar folds por nível" })

      -- Peek: visualiza o fold sem abrir; se não tiver fold, mostra hover LSP
      vim.keymap.set("n", "K", function()
        local winid = ufo.peekFoldedLinesUnderCursor()
        if not winid then
          vim.lsp.buf.hover()
        end
      end, { desc = "Peek fold ou Hover LSP" })
    end,
  },
}
