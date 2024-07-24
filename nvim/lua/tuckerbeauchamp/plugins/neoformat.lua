return {
	"sbdchd/neoformat",
	config = function()
		vim.api.nvim_create_autocmd({ "BufWritePre" }, {
			pattern = { "*.lua", "*.js", "*.jsx", "*.tsx", "*.ts", "*.css", "*.html", "*.md" },
			command = "Neoformat",
		})
	end,
}
