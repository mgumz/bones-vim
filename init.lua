require('nvim-web-devicons').setup()

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/vimrc')

vim.cmd('packadd! nvim-snacks')
vim.cmd('packadd! nvim-aerial')
vim.cmd('packadd! nvim-gitsigns')
vim.cmd('packadd! nvim-smear-cursor')
vim.cmd('packadd! nvim-plenary')
vim.cmd('packadd! nvim-trouble')
vim.cmd('packadd! nvim-todo-comments')
vim.cmd('packadd! nvim-mini')
vim.cmd('packadd! nvim-fzf')

vim.cmd('packadd! nvim-lspconfig')
vim.cmd('packadd! nvim-treesitter')
vim.cmd('packadd! nvim-treesitter-textobjects')
vim.cmd('packadd! nvim-treesitter-context')
vim.cmd('packadd! nvim-render-markdown')

require('gitsigns').setup()
require('smear_cursor').setup()
require('aerial').setup()
require('todo-comments').setup()
require('trouble').setup()

-- https://github.com/folke/snacks.nvim
require('snacks').setup({
    explorer = { enabled = true },
    indent = { enabled = true },
    image = { enabled = true },
    lazygit = { enabled = true },
    picker = { enabled = true },
    terminal = { enabled = true },
})

vim.keymap.set('n', ',p<space>', function() Snacks.picker() end)
vim.keymap.set('n', ',of', function() Snacks.picker('explorer') end)
vim.keymap.set('n', ',pf', function() Snacks.picker('files') end)
vim.keymap.set('n', ',oa', function() ArialToggle() end)


-- https://github.com/echasnovski/mini.nvim
require('mini.pairs').setup({})

-- https://github.com/nvim-treesitter/nvim-treesitter
local dp = vim.fn.stdpath('data') .. '/treesitter'
vim.opt.runtimepath:prepend(dp)
require'nvim-treesitter.configs'.setup({
    parser_install_dir = dp,
    ensure_installed = { "awk", 
        "c", "csv", "cpp",
        "dockerfile",
        "erlang", "elixir",
        "go", "gomod", "gotmpl", "git_config", "gitcommit", "gitignore",
        "json",
        "markdown",
        "python",
        "regex", "rust",
        "swift",
        "tsv", "tmux", "typst",
        "vim",
        "yaml",
    },
    highlight = {
        enable = true,
    },
    textobjects = {
        select = {
            enable = true
        }
    },
})

require('treesitter-context').setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false, -- Enable multiwindow support.
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20, -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})

vim.lsp.config('gopls', {
    -- on_attach = lsp_status.on_attach,
    settings = {
        gopls = {
            analyses = {
                unusedparams = true
            },
            staticcheck = true
        }
    }
})
vim.lsp.config('clangd', {
    cmd = {'clangd', '--background-index', '--clang-tidy', '--log=verbose', '--query-driver=/usr/bin/cc'},
    init_options = {
        -- fallbackFlags = { '-std=c++17' },
    },
})
vim.lsp.config('harper_ls', {})
vim.lsp.config('marksman', {})
vim.lsp.config('rust_analyzer', {
    settings = {
        ['rust-analyzer'] = {
            diagnostics = {
                enable = false;
            }
        }
    }
})
vim.lsp.config('helm_ls', {
    settings = {
        ['helm-ls'] = {
            yamlls = {
                path = "yaml-language-server",
            }
        }
    }
})
vim.lsp.config('yamlls', {})
vim.lsp.config('ruff', {
    init_options = {
        configuration = {

        },
        settings = {
            lineLength = 80,
            showSyntaxErrors = true
        }
    }
})

