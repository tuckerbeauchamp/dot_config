function ToggleInlayHints()
	vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

vim.api.nvim_create_user_command("ToggleInlayHints", ToggleInlayHints, {})
