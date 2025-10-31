return 
{'akinsho/bufferline.nvim', version = "*", dependencies = 'nvim-tree/nvim-web-devicons',
    config = function ()
        vim.keymap.set("n", "<C-h>", "<cmd>bprev<CR>")
        vim.keymap.set("n", "<C-l>", "<cmd>bnext<CR>")
        vim.keymap.set("n", "<S-l>", "<cmd>BufferLineCycleNext<CR>")
        vim.keymap.set("n", "<S-h>", "<cmd>BufferLineCyclePrev<CR>")
    end
}
