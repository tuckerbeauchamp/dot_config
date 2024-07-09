local function filter_definitions(result)
	if not result then
		return
	end
	local filtered_result = {}
	for _, item in ipairs(result) do
		if item.targetUri and not item.targetUri:match("%.d%.ts$") then
			table.insert(filtered_result, item)
		end
	end
	return filtered_result
end

return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"folke/neodev.nvim",
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "j-hui/fidget.nvim", opts = {} },
			-- Autoformatting
			"stevearc/conform.nvim",
			-- Schema information
			"b0o/SchemaStore.nvim",
		},
		config = function()
			require("neodev").setup({
				-- library = {
				--   plugins = { "nvim-dap-ui" },
				--   types = true,
				-- },
			})

			local capabilities = nil
			if pcall(require, "cmp_nvim_lsp") then
				capabilities = require("cmp_nvim_lsp").default_capabilities()
			end

			local lspconfig = require("lspconfig")

			local servers = {
				bashls = true,
				lua_ls = true,
				rust_analyzer = true,
				svelte = true,
				cssls = true,

				-- Probably want to disable formatting for this lang server
				tsserver = {
					filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
				},

				jsonls = {
					settings = {
						json = {
							schemas = require("schemastore").json.schemas(),
							validate = { enable = true },
						},
					},
				},

				yamlls = {
					settings = {
						yaml = {
							schemaStore = {
								enable = false,
								url = "",
							},
							schemas = require("schemastore").yaml.schemas(),
						},
					},
				},
			}

			local servers_to_install = vim.tbl_filter(function(key)
				local t = servers[key]
				if type(t) == "table" then
					return not t.manual_install
				else
					return t
				end
			end, vim.tbl_keys(servers))

			require("mason").setup()
			local ensure_installed = {
				"stylua",
				"lua_ls",
				-- "tailwind-language-server",
			}

			vim.list_extend(ensure_installed, servers_to_install)
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			for name, config in pairs(servers) do
				if config == true then
					config = {}
				end
				config = vim.tbl_deep_extend("force", {}, {
					capabilities = capabilities,
				}, config)

				lspconfig[name].setup(config)
			end

			local disable_semantic_tokens = {
				lua = true,
			}

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf
					local client = assert(vim.lsp.get_client_by_id(args.data.client_id), "must have valid client")

					vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, { buffer = 0 })
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = 0 })
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, { buffer = 0 })
					vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, { buffer = 0 })
					vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = 0 })

					vim.keymap.set("n", "<space>cr", vim.lsp.buf.rename, { buffer = 0 })
					vim.keymap.set("n", "<space>ca", vim.lsp.buf.code_action, { buffer = 0 })

					local filetype = vim.bo[bufnr].filetype
					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end
				end,
			})

			-- Autoformatting Setup
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					javascript = { "prettier" },
				},
			})

			-- working on ignoring .d.ts files
			-- require("lspconfig").tsserver.setup({
			-- 	on_attach = function(client, bufnr)
			-- 		-- Disable "Go to Definition" for .d.ts files
			-- 		client.handlers["textDocument/definition"] = function(err, result, ctx, config)
			-- 			if err then
			-- 				vim.notify(err.message, vim.log.levels.ERROR)
			-- 				return nil
			-- 			end
			--
			-- 			if not result or vim.tbl_isempty(result) then
			-- 				vim.notify("No definitions found", vim.log.levels.INFO)
			-- 				return nil
			-- 			end
			--
			-- 			local filtered_result = filter_definitions(result)
			-- 			if #filtered_result > 0 then
			-- 				local item = filtered_result[1]
			-- 				if item.targetUri then
			-- 					local start_pos = item.targetRange or item.targetSelectionRange
			-- 					if start_pos then
			-- 						local row, col = start_pos.start.line, start_pos.start.character
			-- 						vim.api.nvim_win_set_cursor(0, { row + 1, col })
			-- 						vim.api.nvim_command("normal! zz")
			-- 					end
			-- 				end
			-- 			else
			-- 				vim.notify("No non-.d.ts definitions found", vim.log.levels.INFO)
			-- 			end
			-- 		end
			-- 	end,
			-- 	require("cmp_nvim_lsp").default_capabilities(),
			-- })

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = true,
						quiet = true,
					})
				end,
			})
		end,
	},
}
