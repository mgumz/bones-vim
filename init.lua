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
	"nvim-mini",
	"nvim-plenary",
	"nvim-render-markdown",
	"nvim-smear-cursor",
	"nvim-snacks",
	"nvim-todo-comments",
	"nvim-treesitter",
	"nvim-treesitter-context",
	"nvim-treesitter-textobjects",
	"nvim-trouble",
	"nvim-web-devicons",
    "nvim-lualine",
}
for _, p in ipairs(packs) do vim.cmd("packadd! " .. p) end

-------------------------------------------------------------------------------

require("nvim-web-devicons").setup()
require("gitsigns").setup()
require("smear_cursor").setup()
require("aerial").setup()
require("todo-comments").setup()
require("trouble").setup()

-- https://github.com/folke/snacks.nvim
require("snacks").setup({
	dim = { enabled = true },
	explorer = { enabled = true },
	indent = { enabled = true },
	image = { enabled = true },
	lazygit = { enabled = true },
	picker = { enabled = true },
	terminal = { enabled = true },
})

-- https://github.com/nvim-lualine/lualine.nvim
require("lualine").setup()

-- https://github.com/echasnovski/mini.nvim
require("mini.pairs").setup({})

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
		"python",
		"regex",
		"rust",
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
	enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
	multiwindow = false, -- Enable multiwindow support.
	max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
	min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
	line_numbers = true,
	multiline_threshold = 20, -- Maximum number of lines to show for a single context
	trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
	mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
	-- Separator between context and content. Should be a single character string, like '-'.
	-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
	separator = nil,
	zindex = 20, -- The Z-index of the context window
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
			-- on_attach = lsp_status.on_attach,
			settings = {
				gopls = {
					analyses = {
						unusedparams = true,
					},
					staticcheck = true,
				},
			},
		},
	},
	harper_ls = { enable = true, config = {} },
	marksman = { enable = true, config = {} },
	yamlls = { enable = true, config = {} },
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
}

for n, l in pairs(lsp_config) do
	vim.lsp.config(n, l.config)
	if (l.enable == true) then vim.lsp.enable(n) end
end

-------------------------------------------------------------------------------
-------------------------------------------------------------------------------

vim.keymap.set("n", ",p<space>", function() Snacks.picker() end)
vim.keymap.set("n", ",pf", function() Snacks.picker("files") end)
vim.keymap.set("n", ",te", function() Snacks.picker("explorer") end)
vim.keymap.set("n", ",ta", function() vim.cmd("AerialToggle") end)

