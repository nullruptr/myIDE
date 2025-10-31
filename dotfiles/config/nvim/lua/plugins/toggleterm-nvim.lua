-- https://github.com/akinsho/toggleterm.nvim
return {
    'akinsho/toggleterm.nvim', version = "*",
    config = function ()
        require('toggleterm').setup{
            open_mapping = [[<c-\>]],
            direction = 'horizontal',
            size = 20,
            shell = "/bin/bash",
        }
    end
}