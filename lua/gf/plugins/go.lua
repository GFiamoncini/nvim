-- Suporte avançado a Go: vim-go + atalhos específicos
return {
  {
    "fatih/vim-go",
    ft    = { "go", "gomod", "gowork", "gotmpl" },
    build = ":GoUpdateBinaries",
    init  = function()
      -- Desativa features que o gopls (LSP) já cobre para evitar conflito
      vim.g.go_def_mapping_enabled    = 0  -- usa LSP para go-to-definition
      vim.g.go_doc_popup_window       = 1
      vim.g.go_fmt_autosave           = 1  -- formata ao salvar
      vim.g.go_fmt_command            = "goimports" -- inclui imports automáticos
      vim.g.go_gopls_enabled          = 0  -- evita conflito com gopls do mason
      vim.g.go_code_completion_enabled = 0 -- usa nvim-cmp
      vim.g.go_highlight_types         = 1
      vim.g.go_highlight_fields        = 1
      vim.g.go_highlight_functions     = 1
      vim.g.go_highlight_function_calls = 1
      vim.g.go_highlight_operators     = 1
      vim.g.go_highlight_extra_types   = 1
      vim.g.go_highlight_build_constraints = 1
      vim.g.go_highlight_generate_tags = 1
      vim.g.go_metalinter_autosave     = 0 -- usa nvim-lint
      vim.g.go_test_show_name          = 1
    end,
    config = function()
      local map = vim.keymap.set

      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "go", "gomod" },
        callback = function()
          local opts = function(desc)
            return { buffer = true, silent = true, desc = desc }
          end

          -- ── Executar / Build ─────────────────────────────────────────────
          map("n", "<leader>gr", "<cmd>GoRun<CR>",                           opts("Go: Run"))
          map("n", "<leader>gb", "<cmd>GoBuild<CR>",                         opts("Go: Build"))
          map("n", "<leader>gi", "<cmd>GoInstall<CR>",                       opts("Go: Install"))

          -- ── Testes ───────────────────────────────────────────────────────
          map("n", "<leader>gt",  "<cmd>GoTest<CR>",                         opts("Go: Test (todos)"))
          map("n", "<leader>gtf", "<cmd>GoTestFunc<CR>",                     opts("Go: Test (função)"))
          map("n", "<leader>gtc", "<cmd>GoTestCompile<CR>",                  opts("Go: Test compile"))
          map("n", "<leader>gco", "<cmd>GoCoverage<CR>",                     opts("Go: Coverage"))

          -- ── Geração de código ─────────────────────────────────────────────
          map("n", "<leader>ge",  "<cmd>GoIfErr<CR>",                        opts("Go: if err != nil"))
          map("n", "<leader>gfs", "<cmd>GoFillStruct<CR>",                   opts("Go: Fill struct"))
          map("n", "<leader>gfsp","<cmd>GoFillSwitch<CR>",                   opts("Go: Fill switch"))
          map("n", "<leader>gat", "<cmd>GoAddTags<CR>",                      opts("Go: Add tags"))
          map("n", "<leader>grt", "<cmd>GoRemoveTags<CR>",                   opts("Go: Remove tags"))

          -- ── Imports ───────────────────────────────────────────────────────
          map("n", "<leader>gim", "<cmd>GoImports<CR>",                      opts("Go: Organizar imports"))

          -- ── Alternância de arquivo ────────────────────────────────────────
          map("n", "<leader>ga",  "<cmd>GoAlternate!<CR>",                   opts("Go: Alternar impl/test"))
          map("n", "<leader>gA",  "<cmd>GoAlternate<CR>",                    opts("Go: Alternar (split)"))

          -- ── Documentação ─────────────────────────────────────────────────
          map("n", "<leader>gd",  "<cmd>GoDoc<CR>",                          opts("Go: Doc"))

          -- ── Lint / Vet ────────────────────────────────────────────────────
          map("n", "<leader>gv",  "<cmd>GoVet<CR>",                          opts("Go: Vet"))
          map("n", "<leader>gln", "<cmd>GoLint<CR>",                         opts("Go: Lint"))
        end,
      })
    end,
  },
}
