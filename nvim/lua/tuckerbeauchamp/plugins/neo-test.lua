return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"nvim-neotest/neotest-jest",
	},
	event = {
		"BufReadPost */__tests__/*",
	},
	config = function()
		require("neotest").setup({
			-- Configure Jest adapter
			adapters = {
				require("neotest-jest")({
					jestCommand = "npx jest  --json",
					jestConfigFile = "jest.config.js",
					env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
			},
		})

		-- Keymaps
		vim.keymap.set("n", "<leader>tt", function()
			require("neotest").run.run(vim.fn.expand("%"))
		end, { desc = "Run File" })

		vim.keymap.set("n", "<leader>tn", function()
			require("neotest").run.run()
		end, { desc = "Run Nearest" })

		vim.keymap.set("n", "<leader>ts", function()
			require("neotest").summary.toggle()
		end, { desc = "Toggle Summary" })

		vim.keymap.set("n", "<leader>to", function()
			require("neotest").output.open({ enter = true, auto_close = true })
		end, { desc = "Show Output" })

		vim.keymap.set("n", "<leader>tO", function()
			require("neotest").output_panel.toggle()
		end, { desc = "Toggle Output Panel" })

		vim.keymap.set("n", "[t", function()
			require("neotest").jump.prev({ status = "failed" })
		end, { desc = "Previous Failed Test" })

		vim.keymap.set("n", "]t", function()
			require("neotest").jump.next({ status = "failed" })
		end, { desc = "Next Failed Test" })
	end,
}
