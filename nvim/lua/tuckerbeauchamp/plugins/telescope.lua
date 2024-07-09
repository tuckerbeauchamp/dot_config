return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
	config = function()
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, {})

		require("telescope").setup({
			defaults = {
				hidden = true,
				path_display = { truncate = 5 },
				layout_config = {
					prompt_position = "bottom",
					width = 0.95,
					height = 0.95,
				},
				file_ignore_patterns = { "node_modules", ".git", ".next" },
			},
		})
	end,
}
