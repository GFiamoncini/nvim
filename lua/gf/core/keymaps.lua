-- ── Leader ────────────────────────────────────────────────────────────────
vim.g.mapleader = " "
local map = vim.keymap.set

-- ── Modo Comando ──────────────────────────────────────────────────────────
map("n", ";", ":", { noremap = true, desc = "Entrar no modo comando" })

-- ── Escape rápido ─────────────────────────────────────────────────────────
map("i", "jk", "<ESC>", { desc = "Sair do insert com jk" })

-- ── Busca ─────────────────────────────────────────────────────────────────
map("n", "<leader>nh", ":nohl<CR>",        { desc = "Limpar highlight de busca" })
map({ "n", "v" }, "<leader>hh", ":set hls!<CR>", { desc = "Toggle highlight de busca" })

-- ── Quebra de linha ───────────────────────────────────────────────────────
map({ "n", "v" }, "<F3>", ":set wrap!<CR>", { desc = "Toggle quebra de linha" })

-- ── Números ───────────────────────────────────────────────────────────────
map("n", "<leader>+", "<C-a>", { desc = "Incrementar número" })
map("n", "<leader>-", "<C-x>", { desc = "Decrementar número" })

-- ── Janelas (splits) ──────────────────────────────────────────────────────
map("n", "<leader>sv", "<C-w>v",         { desc = "Split vertical" })
map("n", "<leader>sh", "<C-w>s",         { desc = "Split horizontal" })
map("n", "<leader>se", "<C-w>=",         { desc = "Equalizar splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Fechar split atual" })

-- ── Tabs ──────────────────────────────────────────────────────────────────
map("n", "<leader>to", "<cmd>tabnew<CR>",    { desc = "Nova tab" })
map("n", "<leader>tx", "<cmd>tabclose<CR>",  { desc = "Fechar tab" })
map("n", "<leader>tn", "<cmd>tabn<CR>",      { desc = "Próxima tab" })
map("n", "<leader>tp", "<cmd>tabp<CR>",      { desc = "Tab anterior" })
map("n", "<leader>tf", "<cmd>tabnew %<CR>",  { desc = "Buffer atual em nova tab" })

-- ── Folding (complementa os do nvim-ufo em folding.lua) ───────────────────
-- zR / zM / zr / zm são mapeados pelo nvim-ufo
map("n", "<leader>fo", "zR", { desc = "Abrir todos os folds" })
map("n", "<leader>fc", "zM", { desc = "Fechar todos os folds" })
map("n", "<leader>fa", "za", { desc = "Toggle fold sob cursor" })
