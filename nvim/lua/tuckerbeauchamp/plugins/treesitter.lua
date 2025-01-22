return {
	"nvim-treesitter/nvim-treesitter",
	dependencies = {
		{
			"nvim-treesitter/nvim-treesitter-textobjects",
			lazy = true,
		},
	},
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ignore_install = {},
			modules = {},
			indent = { enable = true },

			-- Install parsers synchronously (only applied to `ensure_installed`)
			sync_install = false,

			-- Automatically install missing parsers when entering buffer
			-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
			auto_install = true,

			highlight = {
				enable = true,
				-- Using this option may slow down your editor, and you may see some duplicate highlights.
				additional_vim_regex_highlighting = false,
			},

			ensure_installed = {
				"javascript",
				"jsdoc",
				"markdown",
				"typescript",
				"lua",
				"rust",
				"vim",
				"vimdoc",
				"query",
				"graphql",
			},

			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-s>",
					node_incremental = "<C-s>",
					scope_incremental = false,
					node_decremental = "<bs>",
				},
			},
		})
	end,
}
