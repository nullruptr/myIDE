-- https://eiji.page/blog/neovim-lazy-nvim-intro/ -> わかりやすい
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
vim.opt.number = true
vim.opt.clipboard = "unnamedplus"
vim.opt.splitright = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Web系ファイルは2スペースインデント
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "typescript", "typescriptreact", "javascript", "javascriptreact", "html", "css", "json" },
    callback = function()
        vim.opt_local.shiftwidth = 2
        vim.opt_local.tabstop = 2
        vim.opt_local.softtabstop = 2
        vim.opt_local.expandtab = true
    end,
})