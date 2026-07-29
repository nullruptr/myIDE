local parsers = {
  "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline",
  "html", "css", "javascript", "dockerfile", "latex", "python", "rust",
  "toml", "typescript", "tsx",
}

return {
    'nvim-treesitter/nvim-treesitter', branch = 'main', lazy = false, build = ":TSUpdate",
    config = function ()
        require('nvim-treesitter').install(parsers)

        vim.api.nvim_create_autocmd('FileType', {
            pattern = parsers,
            callback = function(ev)
                -- Skip highlighting for large files to avoid slowdowns
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(ev.buf))
                if ok and stats and stats.size > max_filesize then
                    return
                end
                vim.treesitter.start(ev.buf)
            end,
        })
    end
}