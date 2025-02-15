return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
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
				sqlls = {
					filetypes = { "sql" },
					connections = {
						{
							driver = "postgresql", -- or 'postgresql'
							dataSourceName = "postgresadmin:admin123@tcp(localhost:5432)/sandbox-1",
						},
					},
				},

				graphql = {
					cmd = { "graphql-lsp", "server", "-m", "stream" },
					filetypes = { "graphql", "javascript", "javascriptreact", "typescript", "typescriptreact" },
					root_dir = require("lspconfig.util").root_pattern(
						".graphqlrc",
						".graphqlrc.yaml",
						".graphqlrc.yml",
						"graphql.config.js",
						"graphql.config.yaml",
						"graphql.config.yml"
					),
				},

				ts_ls = {
					init_options = {
						preferences = {
							importModuleSpecifierPreference = "relative",
							includeInlayParameterNameHints = "all",
						},
					},
					filetypes = { "typescript", "typescriptreact", "javascript", "javascriptreact" },
				},

				jsonls = {
					settings = {
						json = {
							trace = { server = "on" },
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
					vim.keymap.set("n", "<leader>ci", function()
						vim.lsp.buf.code_action({
							context = {
								diagnostics = {},
								only = {
									"source.addMissingImports",
								},
							},
							apply = true, -- This will apply the action automatically without showing the menu
						})
					end, { buffer = 0, desc = "Add All Missing Imports" })

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

			vim.api.nvim_create_autocmd("BufWritePre", {
				callback = function(args)
					require("conform").format({
						bufnr = args.buf,
						lsp_fallback = true,
						quiet = true,
					})
				end,
			})

			local inlay_hints_enabled = true

			local function toggle_inlay_hints()
				inlay_hints_enabled = not inlay_hints_enabled
				for _, client in ipairs(vim.lsp.get_active_clients()) do
					if client.server_capabilities.inlayHintProvider then
						vim.lsp.inlay_hint.enable(0, inlay_hints_enabled)
					end
				end
			end

			vim.api.nvim_set_keymap(
				"n",
				"<leader>th",
				":lua toggle_inlay_hints()<CR>",
				{ noremap = true, silent = true }
			)
		end,
	},
}
