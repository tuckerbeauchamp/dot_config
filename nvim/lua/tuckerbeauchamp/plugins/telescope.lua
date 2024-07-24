return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim", "BurntSushi/ripgrep" },
	config = function()
		local builtin = require("telescope.builtin")

		vim.keymap.set("n", "<leader>pf", function()
			builtin.find_files({ hidden = true, no_ignore = true })
		end)
		vim.keymap.set("n", "<leader>ps", function()
			builtin.grep_string({ search = vim.fn.input("Grep > ") })
		end)
		vim.keymap.set("n", "<leader>pg", builtin.live_grep, {})
		vim.keymap.set("n", "<leader>gd", builtin.lsp_definitions, {})
		vim.keymap.set("n", "<leader>fm", builtin.marks, {})

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
