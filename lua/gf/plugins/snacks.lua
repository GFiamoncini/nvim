-- ~/.config/nvim/lua/gf/plugins/snacks.lua
--
-- Layout (inspirado no exemplo do Pokemon das docs oficiais do snacks.nvim):
--
--  ┌── pane 1 (width=40) ──────┬── pane 2 (width=40) ──────┐
--  │  ███╗   ██╗███████╗ ████  │  ▓▓▒░ imagem ascii  ░▒▓▓  │
--  │  ████╗  ██║██╔════╝ ████  │  ▒▓▓▒░ -C -c flags  ░▒▓▒  │
--  │  ██╔██╗ ██║█████╗   ████  │  ░▒▓▓▒ ascii-image  ▒▓▓░  │
--  │  ...                      │  ░░▒▒▓▓▒░░▒▒▓▓▒░░▒▒▓▓▒░   │
--  │                           │                            │
--  │   Find File          f    │                            │
--  │   New File           n    │                            │
--  │   Find Text          g    │                            │
--  │   Recent Files       r    │                            │
--  │   Config             c    │                            │
--  │   Lazy               L    │                            │
--  │   Quit               q    │                            │
--  │                           │                            │
--  │  ⚡ loaded in Xms         │                            │
--  └───────────────────────────┴────────────────────────────┘
--
-- Total: ~84 colunas (ideal para janelas Forge ~90 cols)
-- Ajuste IMAGE_HEIGHT se a imagem ficar maior/menor que o painel esquerdo.

local IMAGE_PATH   = vim.fn.stdpath("config") .. "/dashboard.png"
local IMAGE_HEIGHT = 22  -- ajuste para a altura da sua imagem

local function image_cmd()
  if vim.fn.executable("ascii-image-converter") == 1
    and vim.fn.filereadable(IMAGE_PATH) == 1
  then
    -- --height controla as linhas; -C = cores; -c = modo complexo (mais detalhe)
    return string.format(
      "ascii-image-converter '%s' -C -c --height %d; sleep .1",
      IMAGE_PATH,
      IMAGE_HEIGHT
    )
  end
  return "echo 'Coloque sua imagem em:' && echo '~/.config/nvim/dashboard.png'"
end

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy     = false,
  opts = {
    dashboard = {
      enabled  = true,
      width    = 40,    -- largura de cada pane; total = 40+4+40 = 84 cols
      pane_gap = 4,

      preset = {
        -- Header NEOVIM em ASCII art (renderizado pelo snacks com highlight)
        header = [[
 ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
 ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
 ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
 ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
 ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
 ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
        keys = {
          { icon = " ", key = "f", desc = "Find File",     action = ":Telescope find_files" },
          { icon = " ", key = "n", desc = "New File",       action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Find Text",      action = ":Telescope live_grep" },
          { icon = " ", key = "r", desc = "Recent Files",   action = ":Telescope oldfiles" },
          { icon = " ", key = "c", desc = "Config",         action = ":e $MYVIMRC" },
          { icon = " ", key = "s", desc = "Restore Session", action = ":SessionRestore" },
          { icon = "󰒲 ", key = "L", desc = "Lazy",           action = ":Lazy", enabled = package.loaded.lazy ~= nil },
          { icon = " ", key = "q", desc = "Quit",           action = ":qa" },
        },
      },

      -- Exatamente o padrão do exemplo Pokemon das docs do snacks.nvim:
      -- pane 1 (default): header + keys + startup
      -- pane 2: terminal com a imagem ascii
      sections = {
        { section = "header" },
        { section = "keys",    gap = 1, padding = 1 },
        { section = "startup" },
        {
          section = "terminal",
          cmd     = image_cmd(),
          pane    = 2,
          indent  = 4,
          height  = IMAGE_HEIGHT,
          padding = 1,
          ttl     = 0,   -- sem cache: roda o comando sempre ao abrir
        },
      },
    },

    -- ── Outros módulos ─────────────────────────────────────────────────────
    notifier = { enabled = true, timeout = 3000, style = "compact" },
    input    = { enabled = true },
    lazygit  = { enabled = true },
    bigfile  = { enabled = true },
    words    = { enabled = true },
    indent   = { enabled = true, animate = { enabled = false } },
    zen      = { enabled = true },
    terminal = { enabled = true },
    scroll   = { enabled = false },
    picker   = { enabled = false },
    statuscolumn = { enabled = false },
  },

  keys = {
    { "<leader>lg",  function() Snacks.lazygit() end,               desc = "Lazygit" },
    { "<leader>gb",  function() Snacks.git.blame_line() end,        desc = "Git Blame linha" },
    { "<leader>gf",  function() Snacks.lazygit.log_file() end,      desc = "Git Log (arquivo)" },
    { "<leader>gl",  function() Snacks.lazygit.log() end,           desc = "Git Log" },
    { "<leader>un",  function() Snacks.notifier.hide() end,         desc = "Fechar notificações" },
    { "<leader>nh2", function() Snacks.notifier.show_history() end,  desc = "Histórico notificações" },
    { "<leader>ft",  function() Snacks.terminal() end,              desc = "Terminal flutuante" },
    { "<leader>z",   function() Snacks.zen() end,                   desc = "Zen mode" },
    { "<leader>bd",  function() Snacks.dashboard() end,             desc = "Dashboard" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end,         desc = "Próxima ocorrência" },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end,        desc = "Ocorrência anterior" },

    -- Preview ascii-image-converter interativo
    { "<leader>ai", function()
        if vim.fn.executable("ascii-image-converter") == 0 then
          Snacks.notify.error("ascii-image-converter não encontrado.\ngo install github.com/TheZoraiz/ascii-image-converter@latest")
          return
        end
        local img = vim.fn.input("Imagem: ", IMAGE_PATH, "file")
        if img == "" then return end
        local h = vim.fn.input("Altura (default " .. IMAGE_HEIGHT .. "): ")
        h = (h == "" or tonumber(h) == nil) and IMAGE_HEIGHT or tonumber(h)
        local result = vim.fn.system(
          ("ascii-image-converter '%s' -C -c --height %d"):format(img, h)
        )
        if vim.v.shell_error ~= 0 then Snacks.notify.error("Erro:\n" .. result); return end
        local lines = vim.split(result, "\n", { trimempty = true })
        local buf   = vim.api.nvim_create_buf(false, true)
        vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
        local win_w = math.min(80, vim.o.columns - 4)
        local win_h = math.min(#lines + 2, vim.o.lines - 4)
        vim.api.nvim_open_win(buf, true, {
          relative = "editor", width = win_w, height = win_h,
          row = math.floor((vim.o.lines - win_h) / 2),
          col = math.floor((vim.o.columns - win_w) / 2),
          style = "minimal", border = "rounded",
          title = " ASCII Preview ", title_pos = "center",
        })
      end, desc = "Preview ASCII (ascii-image-converter)" },

    -- Define imagem do dashboard
    { "<leader>aI", function()
        local img = vim.fn.input("Imagem para o dashboard: ", "", "file")
        if img == "" then return end
        vim.fn.system(("cp '%s' '%s'"):format(img, IMAGE_PATH))
        if vim.v.shell_error ~= 0 then
          Snacks.notify.error("Falha ao copiar.")
        else
          Snacks.notify.info("Feito! Reinicie o Neovim para ver.")
        end
      end, desc = "Definir imagem do dashboard" },
  },
}
