local install_path = vim.fn.stdpath("data") .. "/site/pack/packer/start/lazy.nvim"


if not vim.loop.fs_stat(install_path) then
	vim.fn.system({
		'git', 'clone', '--depth', '1', 'https://github.com/folke/lazy.nvim', install_path
	})
end
vim.opt.rtp:prepend(install_path)

require("lazy").setup({
	{"nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
	config = function()
		require'nvim-treesitter.configs'.setup {
			-- A list of parser names, or "all" (the listed parsers MUST always be installed)
			ensure_installed = { "c", "lua", "typescript", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = true,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			-- List of parsers to ignore installing (or "all")
			-- ignore_install = { "javascript" },

			highlight = {
				enable = true,

				-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
				-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
				-- the name of the parser)
				-- list of language that will be disabled
				disable = { "c", "rust" },
				-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
				disable = function(lang, buf)
					local max_filesize = 100 * 1024 -- 100 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						return true
					end
				end,

				-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
				-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				-- Instead of true it can also be a list of languages
				additional_vim_regex_highlighting = false,
			},
		}

	end,

},
{ 'echasnovski/mini.nvim', version = false },
{'xiyaowong/nvim-transparent'},
{
	'stevearc/oil.nvim',
	dependencies = { { "echasnovski/mini.icons", opts = {} } },
	lazy = false,
},
{'nvim-lua/plenary.nvim'},
{
	'ThePrimeagen/harpoon'
},
{
	'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
},
{
	'neovim/nvim-lspconfig',
	dependencies = {
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the `vim.uv` word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		},
	},

	config = function()
		require("lspconfig").lua_ls.setup {
			cmd = { "/home/em/bin/lua_language_server/bin/lua-language-server" },
		}
	end,
},

{
	"scottmckendry/cyberdream.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("cyberdream").setup({
			variant = "auto",
			transparent = true,
			italic_comments = true,
			hide_fillchars = true,
			terminal_colors = false,
			cache = true,
			borderless_pickers = true,
			overrides = function(c)
				return {
					CursorLine = { bg = c.bg },
					CursorLineNr = { fg = c.magenta },
				}
			end,
		})

		vim.cmd("colorscheme cyberdream")
	end,
}
})

-- Set leader key to space
vim.g.mapleader = " "

-- Setup Mini plugins
require('mini.comment').setup()
require('mini.operators').setup()
require('mini.pairs').setup()
require('mini.snippets').setup()
require('mini.icons').setup()
require('mini.tabline').setup()
require('mini.trailspace').setup()
require('mini.indentscope').setup()
require('mini.notify').setup()
require('mini.starter').setup()
require('mini.statusline').setup()
require('mini.git').setup()
require('mini.diff').setup()
require('mini.fuzzy').setup()
require('mini.sessions').setup()

-- Setup other plugins
require("oil").setup()
require('harpoon').setup()

-- Telescope keymaps
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
vim.keymap.set('n', '<leader>en', function()
	require("telescope.builtin").find_files {
		cwd = vim.fn.stdpath("config")
	}
end)

-- Harpoon keymaps
vim.keymap.set('n', '<leader>ha', require('harpoon.mark').add_file, { desc = 'Harpoon add file' })
vim.keymap.set('n', '<leader>hh', require('harpoon.ui').toggle_quick_menu, { desc = 'Harpoon quick menu' })
vim.keymap.set('n', '<leader>1', function() require('harpoon.ui').nav_file(1) end, { desc = 'Harpoon go to mark 1' })
vim.keymap.set('n', '<leader>2', function() require('harpoon.ui').nav_file(2) end, { desc = 'Harpoon go to mark 2' })
vim.keymap.set('n', '<leader>3', function() require('harpoon.ui').nav_file(3) end, { desc = 'Harpoon go to mark 3' })
vim.keymap.set('n', '<leader>4', function() require('harpoon.ui').nav_file(4) end, { desc = 'Harpoon go to mark 4' })

-- General settings
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_keymap('i', 'jk', '<esc>', { noremap = true, silent = true })

vim.cmd("colorscheme cyberdream")
