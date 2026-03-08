vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- ── Números ───────────────────────────────────────────────────────────────
opt.relativenumber = true
opt.number         = true

-- ── Indentação ────────────────────────────────────────────────────────────
opt.tabstop    = 2
opt.shiftwidth = 2
opt.expandtab  = true
opt.autoindent = true

-- ── Linha ─────────────────────────────────────────────────────────────────
opt.wrap       = false
opt.cursorline = true

-- ── Busca ─────────────────────────────────────────────────────────────────
opt.ignorecase = true
opt.smartcase  = true

-- ── Aparência ─────────────────────────────────────────────────────────────
opt.termguicolors = true
opt.background    = "dark"
opt.signcolumn    = "yes"

-- ── Clipboard ─────────────────────────────────────────────────────────────
opt.clipboard:append("unnamedplus")

-- ── Backspace ─────────────────────────────────────────────────────────────
opt.backspace = "indent,eol,start"

-- ── Splits ────────────────────────────────────────────────────────────────
opt.splitright = true
opt.splitbelow = true

-- ── Misc ──────────────────────────────────────────────────────────────────
opt.swapfile   = false
opt.scrolloff  = 8        -- mantém 8 linhas de contexto ao rolar

-- ── Folding (configuração base; nvim-ufo complementa em runtime) ──────────
opt.foldmethod    = "expr"
opt.foldexpr      = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel     = 99
opt.foldlevelstart = 99
opt.foldenable    = true

-- ── Markdown ──────────────────────────────────────────────────────────────
opt.conceallevel = 2  -- render-markdown precisa de conceal >= 1
