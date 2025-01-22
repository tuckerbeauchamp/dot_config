return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("fzf-lua").setup({
			winopts = {
				height = 0.8,
				width = 0.9,
				preview = {
					border = "rounded",
					wrap = "nowrap",
				},
				-- hl = {
				-- 	normal = "Normal",
				-- 	border = "FloatBorder",
				-- },
				backdrop = 50,

				-- previewer = {
				-- 	default = "builtin",
				-- 	winblend = 0,
				-- },
			},
			keymap = {
				fzf = {
					["ctrl-q"] = "select-all+accept",
				},
			},
		})

		vim.keymap.set("n", "<leader>pf", require("fzf-lua").files, { desc = "Fzf Files" })
		vim.keymap.set("n", "<leader>ps", function()
			local search_term = vim.fn.input("Grep > ")
			if search_term ~= "" then
				require("fzf-lua").grep({
					search = search_term,
					prompt = "Grep❯ ",
					cmd = "rg --column --line-number --no-heading --color=always --smart-case "
						.. "--hidden --glob '!.git' --glob '!node_modules' "
						.. vim.fn.shellescape(search_term),
					fzf_opts = {
						["--delimiter"] = ":",
					},
				})
			end
		end, { desc = "Grep with input" })

		vim.keymap.set("n", "<leader>pg", function()
			require("fzf-lua").live_grep({
				prompt = "LiveGrep❯ ",
				cmd = "rg --column --line-number --no-heading --color=always --smart-case "
					.. "--hidden --glob '!.git' --glob '!node_modules'",
				fzf_opts = {
					["--delimiter"] = ":",
					["--bind"] = "change:reload:sleep 0.1; rg --column --line-number --no-heading "
						.. "--color=always --smart-case {q} || true",
				},
			})
		end, { desc = "Live grep" })

		-- Marks (equivalent to <leader>fm)
		vim.keymap.set("n", "<leader>fm", function()
			require("fzf-lua").marks({
				prompt = "Marks❯ ",
				fzf_opts = {
					["--delimiter"] = " ",
					["--with-nth"] = "1,4..", -- Show mark and content
					["--preview-window"] = "up:60%:wrap",
				},
				actions = {
					["default"] = function(selected)
						-- Jump to mark and center screen
						local mark = selected[1]:match("^%s*([^%s]+)")
						vim.cmd("normal! '" .. mark .. "zz")
					end,
				},
			})
		end, { desc = "Show marks" })
	end,
}
