-------------------------------------------------------------------------------
-- author: mathias gumz
--   file: init.lua
-------------------------------------------------------------------------------

vim.cmd("source " .. vim.fn.stdpath("config") .. "/vimrc")

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local function load(name, version)
    if (version ~= nil) and (vim.fn.has(version) == 0) then
        return
    end
    local c = "packadd! " .. name
    --   print(name, version, c)
    vim.cmd(c)
end

local function setup(name, opts)
    local ok, pack = pcall(require, name)
    if ok then
        pack.setup(opts)
    end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

local packs = {
    { "nvim-aerial", nvim = "nvim-0.8" },
    { "nvim-fzf", nvim = "nvim-0.9" },
    { "nvim-gitsigns", nvim = "nvim-0.9" },
    { "nvim-lspconfig", nvim = "nvim-0.10" },
    { "nvim-lualine", nvim = "nvim-0.7" },
    { "nvim-neotree", nvim = "nvim-0.8" },
    { "nvim-nui", nvim = "nvim-0.5" },
    { "nvim-plenary", nvim = "nvim-0.8" },
    { "nvim-render-markdown", nvim = "nvim-0.10" },
    { "nvim-smear-cursor", nvim = "0.10.2" },
    { "nvim-snacks", nvim = "nvim-0.9.4" },
    { "nvim-todo-comments", nvim = "nvim-0.8" },
    { "nvim-treesitter", nvim = "nvim-0.10" },
    { "nvim-treesitter-context", nvim = "nvim-0.10" },
    { "nvim-treesitter-textobjects", nvim = "nvim-0.10" },
    { "nvim-trouble", nvim = "nvim-0.9" },
    { "nvim-web-devicons", nvim = "nvim-0.7.0" },
    { "nvim-which-key", nvim = "nvim-0.9.4" },
}

for _, p in ipairs(packs) do
    load(p[1], p.nvim)
end

-------------------------------------------------------------------------------

setup("nvim-web-devicons", {})
setup("gitsigns", {
    signcolumn = true,
    numhl = true,
    --	word_diff = true,
})
setup("neo-tree")
setup("smear_cursor")
setup("aerial")
setup("todo-comments")
setup("trouble")
setup("which-key", {
    preset = "modern",
    win = { border = "rounded" },
    -- triggers = {
    --     { "<leader>", mode = { "n", "v" } },
    -- }
})

-- https://github.com/folke/snacks.nvim
setup("snacks", {
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
setup("lualine")

-- https://github.com/MeanderingProgrammer/render-markdown.nvim#setup
setup('render-markdown', {
    heading = {
        enabled = false
    }
})

-- https://github.com/nvim-treesitter/nvim-treesitter
local dp = vim.fn.stdpath("data") .. "/treesitter"
vim.opt.runtimepath:prepend(dp)
setup("nvim-treesitter.configs", {
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

setup("treesitter-context", {
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
        enable = false,
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
    if l["config"] ~= nil and vim["lsp"] and vim.lsp["config"] then
        vim.lsp.config(n, l.config)
        if (l.enable == true) then vim.lsp.enable(n) end
    end
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

