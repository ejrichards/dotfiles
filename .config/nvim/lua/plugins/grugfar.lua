return {
	"MagicDuck/grug-far.nvim",
	config = function()
		local far = require("grug-far")
		far.setup({
			windowCreationCommand = "tabnew %",
		})

		vim.keymap.set({ "n", "x" }, "<leader>er", far.grug_far, { desc = "grug-far" })

		local far_augroup = vim.api.nvim_create_augroup("grug-far", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "grug-far" },
			group = far_augroup,
			command = "setl bufhidden=wipe",
		})
	end,
}
