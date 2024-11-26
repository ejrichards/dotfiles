return {
	"folke/noice.nvim",
	version = "*",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
	},
	config = function()
		local noice = require("noice")

		noice.setup({
			messages = {
				view_search = false,
			},
			lsp = {
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			presets = {
				bottom_search = true,
			},
			routes = {
				{
					view = "mini",
					filter = { cmdline = "^:w" },
				},
				{
					view = "mini",
					filter = { cmdline = "^:cd" },
				},
			},
			redirect = {
				view = "mini",
				filter = { event = "msg_show" },
			},
		})

		vim.keymap.set("n", "<leader>cd", function()
			vim.cmd.CD()
			noice.redirect("pwd")
		end, { desc = ":cd to current buffer" })

		vim.opt.showmode = false
		-- Trying no showcmd for now
		-- vim.opt.showcmdloc = 'statusline'
		vim.opt.showcmd = false
	end,
}
