require("gf.core")
require("gf.lazy")

vim.api.nvim_create_autocmd("VimLeave", {
  callback = function()
    vim.cmd([[set guicursor=a:ver25]])
    os.execute("echo -ne '\\e[6 q'") -- Restaura o cursor barra "|"
  end,
})
