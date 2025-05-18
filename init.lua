-------------------------------------------------------------------------------
-- author: mathias gumz
--   file: init.lua
-------------------------------------------------------------------------------

vim.cmd("source " .. vim.fn.stdpath("config") .. "/vimrc")

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local packs = {
    "nvim-aerial",
    "nvim-fzf",
    "nvim-gitsigns",
    "nvim-lspconfig",
    "nvim-lualine",
    "nvim-neotree",
    "nvim-plenary",
    "nvim-nui",
    "nvim-render-markdown",
    "nvim-smear-cursor",
    "nvim-snacks",
    "nvim-todo-comments",
    "nvim-treesitter",
    "nvim-treesitter-context",
    "nvim-treesitter-textobjects",
    "nvim-trouble",
    "nvim-web-devicons",
    "nvim-which-key",
}
for _, p in ipairs(packs) do vim.cmd("packadd! " .. p) end

-------------------------------------------------------------------------------

require("nvim-web-devicons").setup()
require("gitsigns").setup({
    signcolumn = true,
    numhl = true,
    --	word_diff = true,
})
require("neo-tree").setup()
require("smear_cursor").setup()
require("aerial").setup()
require("todo-comments").setup()
require("trouble").setup()
require("which-key").setup({
    preset = "modern",
    win = { border = "rounded" },
    -- triggers = {
    --     { "<leader>", mode = { "n", "v" } },
    -- }
})


-- https://github.com/folke/snacks.nvim
require("snacks").setup({
    dim = { enabled = true },
    -- explorer = { enabled = true },
    indent = { enabled = true, scope = { enabled = false }, animate = { enabled = false } },
    image = { enabled = true },
    lazygit = { enabled = true },
    picker = { enabled = true },
    scroll = { enabled = true },
    terminal = { enabled = true },
    statuscolumn = { enabled = false },
})

-- https://github.com/nvim-lualine/lualine.nvim
require("lualine").setup()

-- https://github.com/MeanderingProgrammer/render-markdown.nvim#setup
require('render-markdown').setup({
    heading = {
        enabled = false
    }
})

-- https://github.com/nvim-treesitter/nvim-treesitter
local dp = vim.fn.stdpath("data") .. "/treesitter"
vim.opt.runtimepath:prepend(dp)
require("nvim-treesitter.configs").setup({
    parser_install_dir = dp,
    ensure_installed = {
        "awk",
        "bash",
        "c",
        "csv",
        "cpp",
        "dockerfile",
        "erlang",
        "elixir",
        "go",
        "gomod",
        "gotmpl",
        "git_config",
        "gitcommit",
        "gitignore",
        "json",
        "lua",
        "markdown", "markdown_inline",
        "powershell",
        "python",
        "regex",
        "rust",
        "ssh_config",
        "swift",
        "tsv",
        "tmux",
        "typst",
        "vim",
        "yaml",
    },
    highlight = { enable = true, },
    textobjects = { select = { enable = true, }, },
})

require("treesitter-context").setup({
    enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
    multiwindow = false,      -- Enable multiwindow support.
    max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
    min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    line_numbers = true,
    multiline_threshold = 20, -- Maximum number of lines to show for a single context
    trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
    zindex = 20,     -- The Z-index of the context window
    on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
})

local lsp_config = {
    clangd = {
        enable = true,
        config = {
            cmd = { "clangd", "--background-index", "--clang-tidy", "--log=verbose", "--query-driver=/usr/bin/cc" },
            init_options = {
                -- fallbackFlags = { '-std=c++17' },
            },
        },
    },
    gopls = {
        enable = true,
        config = {
            settings = {
                gopls = {
                    analyses = {
                        unusedparams = true,
                        composites = false,
                    },
                    -- staticcheck = true,
                },
            },
        },
    },
    harper_ls = { enable = false, config = {} },
    lua_ls = { enable = true, config = {} }, -- see .luarc.json
    marksman = { enable = true, config = {} },
    powershell_es = {
        enable = true,
        config = {
            bundle_path = "/Users/mg/.cache/powershell/pses/PowerShellEditorServices",
            cmd = {
                "pwsh",
                    "-NoLogo",
                    "-NoProfile",
                    "-Command", "~/.cache/powershell/pses/PowerShellEditorServices/Start-EditorServices.ps1",
                    "-SessionDetailsPath", "~/.cache/powershell/ps-ls-session.json",
            },
        },
    },
    rust_analyzer = {
        enable = true,
        config = { settings = { ["rust-analyzer"] = { diagnostics = { enable = false } } } },
    },
    helm_ls = {
        enable = true,
        config = { settings = { ["helm-ls"] = { yamlls = { path = "yaml-language-server" } } } },
    },
    ruff = {
        enable = true,
        config = {
            init_options = {
                configuration = {},
                settings = { lineLength = 80, showSyntaxErrors = true },
            },
        },
    },
    yamlls = { enable = true, config = {} },
}

for n, l in pairs(lsp_config) do
    vim.lsp.config(n, l.config)
    if (l.enable == true) then vim.lsp.enable(n) end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local wo = { border = "rounded" }

vim.keymap.set("n", ",?",
    function() require("which-key").show({ global = false }) end,
    { desc = "show keymaps" })
vim.keymap.set("n", ",p<space>",
    function() Snacks.picker() end,
    { desc = "snack picker" })
vim.keymap.set("n", ",pg",
    function() Snacks.lazygit() end,
    { desc = "open lazygit" })
vim.keymap.set("n", ",pfm",
    function() Snacks.terminal("fzf-make", { auto_close = false, win = wo } ) end,
    { desc = "trigger fzf-make" })
vim.keymap.set("n", ",pmc",
    function() Snacks.terminal("mc . .", { win = wo } ) end,
    { desc = "open mc" })
vim.keymap.set("n", ",pk9",
    function() Snacks.terminal("k9s", { win = wo } ) end,
    { desc = "open k9s" })
vim.keymap.set("n", ",pt",
    function() Snacks.terminal(nil) end,
    { desc = "open terminal" })
vim.keymap.set("n", ",tt",
    function() vim.cmd("Neotree toggle") end,
    { desc = "toggle Neotree"})
vim.keymap.set("n", ",ta",
    function() vim.cmd("AerialToggle") end,
    { desc = "toggle Arial"})

