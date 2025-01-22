return {
	{
		"echasnovski/mini.nvim",
		dependencies = {
			"JoosepAlviste/nvim-ts-context-commentstring",
		},
		config = function()
			-- Surround text objects
			require("mini.surround").setup()

			-- Commentting support
			require("mini.comment").setup()
		end,
	},
}
