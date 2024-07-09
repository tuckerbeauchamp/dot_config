return {
	"folke/trouble.nvim",
	opts = {},
	cmd = "Trouble",
	keys = {
		{
			"<leader>xx",
			"<cmd>Trouble diagnostics toggle focus=false filter.buf=0<cr>",
			desc = "Trouble: Toggle diagnostics",
		},
	},
}
