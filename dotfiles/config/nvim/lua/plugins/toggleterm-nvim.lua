-- https://github.com/akinsho/toggleterm.nvim
return {
    'akinsho/toggleterm.nvim', version = "*",
    config = function ()
        local shell = "/bin/bash"
        if vim.fn.has('win32') == 1 then
            shell = "powershell.exe"
        end

        require('toggleterm').setup{
            open_mapping = [[<c-\>]],
            direction = 'horizontal',
            size = 20,
            shell = shell,
        }
    end
}