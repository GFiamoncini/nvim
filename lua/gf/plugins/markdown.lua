-- Suporte completo a Markdown: renderização, preview e atalhos
return {
  -- ── Renderização inline de Markdown ──────────────────────────────────────
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown", "md", "mdx" },
    opts = {
      enabled = true,
      render_modes = { "n", "c" }, -- renderiza em Normal e Comando
      anti_conceal = {
        enabled = true,          -- mostra sintaxe ao mover o cursor para a linha
      },
      heading = {
        enabled  = true,
        sign     = true,
        icons    = { "󰉫 ", "󰉬 ", "󰉭 ", "󰉮 ", "󰉯 ", "󰉰 " },
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },
        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },
      bullet = {
        enabled = true,
        icons   = { "●", "○", "◆", "◇" },
        right_pad = 1,
      },
      checkbox = {
        enabled  = true,
        position = "inline",
        unchecked = { icon = "󰄱 ", highlight = "RenderMarkdownUnchecked" },
        checked   = { icon = "󰱒 ", highlight = "RenderMarkdownChecked" },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },
      code = {
        enabled   = true,
        sign      = false,
        style     = "full",       -- "full" = bloco com borda e destaque de linguagem
        position  = "left",
        language_pad = 0,
        min_width = 45,
        border    = "thin",
        above     = "▄",
        below     = "▀",
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
      },
      dash = {
        enabled   = true,
        icon      = "─",
        width     = "full",
        highlight = "RenderMarkdownDash",
      },
      quote = {
        enabled   = true,
        icon      = "▋",
        repeat_linebreak = false,
        highlight = "RenderMarkdownQuote",
      },
      pipe_table = {
        enabled   = true,
        preset    = "double",   -- borda dupla nas tabelas
        style     = "full",
        cell      = "padded",
        alignment_indicator = "━",
        head      = "RenderMarkdownTableHead",
        row       = "RenderMarkdownTableRow",
        filler    = "RenderMarkdownTableFill",
      },
      link = {
        enabled     = true,
        footnote    = { superscript = true, prefix = "", suffix = "" },
        image       = "󰥶 ",
        email       = "󰀓 ",
        hyperlink   = "󰌹 ",
        highlight   = "RenderMarkdownLink",
        wiki        = { icon = "󱗖 ", highlight = "RenderMarkdownWikiLink" },
        custom = {
          web = { pattern = "^http", icon = "󰖟 ", highlight = "RenderMarkdownLink" },
        },
      },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)

      -- ── Atalhos para modo Normal ──────────────────────────────────────────
      local map = vim.keymap.set
      local md_opts = function(desc)
        return { buffer = true, silent = true, desc = desc }
      end

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "md", "mdx" },
        callback = function()
          -- Toggle rendering
          map("n", "<leader>mr", "<cmd>RenderMarkdown toggle<CR>",         md_opts("Toggle renderização MD"))

          -- ── Modo Normal: navegação ────────────────────────────────────────
          map("n", "]]", function()                                          -- próximo heading
            vim.fn.search("^#\\+\\s", "W")
          end, md_opts("Próximo heading"))

          map("n", "[[", function()                                          -- heading anterior
            vim.fn.search("^#\\+\\s", "bW")
          end, md_opts("Heading anterior"))

          map("n", "]t", "/- \\[ \\]<CR>",                                  md_opts("Próximo todo"))
          map("n", "[t", "?- \\[ \\]<CR>",                                  md_opts("Todo anterior"))

          -- Toggle checkbox: [ ] ↔ [x]
          map("n", "<leader>mt", function()
            local line = vim.api.nvim_get_current_line()
            local new_line
            if line:match("%- %[x%]") then
              new_line = line:gsub("%- %[x%]", "- [ ]", 1)
            elseif line:match("%- %[ %]") then
              new_line = line:gsub("%- %[ %]", "- [x]", 1)
            end
            if new_line then
              vim.api.nvim_set_current_line(new_line)
            end
          end, md_opts("Toggle checkbox MD"))

          -- ── Modo Insert: formatação rápida ────────────────────────────────
          -- Bold: <C-b> envolve a palavra/seleção em **
          map("i", "<C-b>", "****<Left><Left>",                             md_opts("Bold (insert)"))
          -- Italic: <C-i> envolve em _
          map("i", "<C-i>", "__<Left>",                                     md_opts("Italic (insert)"))
          -- Code inline: <C-`>
          map("i", "<C-`>", "``<Left>",                                     md_opts("Code inline (insert)"))
          -- Novo item de lista
          map("i", "<M-l>", "<CR>- ",                                       md_opts("Novo item lista (insert)"))
          -- Novo todo
          map("i", "<M-t>", "<CR>- [ ] ",                                   md_opts("Novo todo (insert)"))

          -- ── Modo Visual: envolver seleção ─────────────────────────────────
          map("v", "<leader>mb", "c****<Esc>hPl",                          md_opts("Bold seleção"))
          map("v", "<leader>mi", "c__<Esc>hPl",                            md_opts("Italic seleção"))
          map("v", "<leader>mc", "c``<Esc>hPl",                            md_opts("Code inline seleção"))
          map("v", "<leader>ms", "c~~~~<Esc>hhPll",                        md_opts("Strikethrough seleção"))
          -- Link: envolve seleção em [seleção](url)
          map("v", "<leader>mk", function()
            local url = vim.fn.input("URL: ")
            if url == "" then return end
            -- Retorna para visual e envolve
            vim.cmd('normal! c[' .. vim.fn.getreg('"') .. '](' .. url .. ')')
          end, md_opts("Link (seleção → [texto](url))"))

          -- Inserir bloco de código
          map("n", "<leader>mC", function()
            local lang = vim.fn.input("Linguagem: ")
            local lines = { "```" .. lang, "", "```" }
            local row = vim.api.nvim_win_get_cursor(0)[1]
            vim.api.nvim_buf_set_lines(0, row, row, false, lines)
            vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
            vim.cmd("startinsert")
          end, md_opts("Inserir bloco de código"))

          -- Inserir tabela simples
          map("n", "<leader>mT", function()
            local cols = tonumber(vim.fn.input("Colunas: ")) or 3
            local header = "| " .. table.concat(
              (function()
                local t = {}
                for i = 1, cols do t[i] = "Col" .. i end
                return t
              end)(),
              " | "
            ) .. " |"
            local sep = "| " .. table.concat(
              (function()
                local t = {}
                for i = 1, cols do t[i] = "---" end
                return t
              end)(),
              " | "
            ) .. " |"
            local row_line = "| " .. table.concat(
              (function()
                local t = {}
                for i = 1, cols do t[i] = "   " end
                return t
              end)(),
              " | "
            ) .. " |"
            local row = vim.api.nvim_win_get_cursor(0)[1]
            vim.api.nvim_buf_set_lines(0, row, row, false, { header, sep, row_line })
          end, md_opts("Inserir tabela"))
        end,
      })
    end,
  },

  -- ── Preview no browser ────────────────────────────────────────────────────
  {
    "iamcco/markdown-preview.nvim",
    cmd   = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft    = { "markdown", "md" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_auto_close  = 1    -- fecha ao trocar de buffer
      vim.g.mkdp_open_to_the_world = 0
      vim.g.mkdp_theme       = "dark"
    end,
    keys = {
      { "<leader>md", "<cmd>MarkdownPreviewToggle<CR>", ft = "markdown", desc = "Markdown Preview (browser)" },
    },
  },
}
