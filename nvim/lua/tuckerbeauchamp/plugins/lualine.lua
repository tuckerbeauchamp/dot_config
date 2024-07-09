return {
	"hoob3rt/lualine.nvim",
	requires = { "kyazdani42/nvim-web-devicons", opt = true },
	dependencies = { "arkav/lualine-lsp-progress", "AndreM222/copilot-lualine", "letieu/harpoon-lualine" },
	config = function()
		require("lualine").setup({
			options = {
				icons_enabled = true,
				component_separators = { left = "", right = "" },
				disabled_filetypes = {},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "diff", "diagnostics" },
				lualine_c = {},
				lualine_x = { "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			winbar = {
				lualine_a = { { "filename", path = 4 }, "branch" },
				lualine_b = {},
				lualine_c = {
					"%=",
					{ "harpoon2", _separator = " " },
					"%=",
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = " " },
					},
				},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = { "quickfix", "fzf", "lazy", "mason", "oil", "trouble" },
		})
	end,
}
