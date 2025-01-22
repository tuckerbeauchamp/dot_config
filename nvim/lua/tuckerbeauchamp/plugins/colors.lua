return {
	-- Themes
	{ "rose-pine/neovim", name = "rose-pine" },
	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		config = function()
			require("tokyonight").setup({})

			vim.cmd("colorscheme tokyonight")
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
	},
}
