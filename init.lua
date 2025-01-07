vim.cmd('source ~/.config/nvim/vimrc')

require'lspconfig'.gopls.setup{}
require'lspconfig'.harper_ls.setup{}
require'lspconfig'.marksman.setup{}

-- https://github.com/nvim-treesitter/nvim-treesitter
require'nvim-treesitter.configs'.setup {
    ensure_installed = { "c", "csv", "cpp",
        "dockerfile",
        "erlang", "elixir",
        "go", "gomod", "gotmpl", "git_config", "gitcommit", "gitignore",
        "markdown",
        "python",
        "rust",
        "tsv", "tmux", "typst",
        "vim", },
    highlight = {
        enable = true,
    }
}

