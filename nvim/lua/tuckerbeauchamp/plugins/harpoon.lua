return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		-- Existing mappings
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)

		vim.keymap.set("n", "<C-e>", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end)

		-- New FZF integration
		vim.api.nvim_create_user_command("HarpoonFzf", function()
			local list = harpoon:list()
			local items = list:display()
			local file_paths = {}

			for _, item in ipairs(items) do
				-- In Harpoon 2.0, each item is a string path
				table.insert(file_paths, item)
			end

			require("fzf-lua").fzf_exec(file_paths, {
				prompt = "Harpoon Files > ",
				actions = {
					["default"] = function(selected)
						vim.cmd("e " .. selected[1])
					end,
				},
			})
		end, {})

		-- Add FZF keybinding
		vim.keymap.set("n", "<C-S-e>", ":HarpoonFzf<CR>", { silent = true })
	end,
}
