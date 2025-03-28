return {
	"ThePrimeagen/harpoon",
	enabled = false,
	-- Currenly an issue with :cd
	commit = "34b419984ea8e04683a49db0200c6d21d493b252",
	config = function()
		local extensions = require("harpoon.extensions")
		local harpoon = require("harpoon"):setup({
			settings = {
				save_on_toggle = true,
			},
		})

		harpoon:extend(extensions.builtins.command_on_nav("UfoEnableFold"))

		-- stylua: ignore start
		vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = "Harpoon Add" })
		vim.keymap.set("n", "<leader>j", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = "Harpoon List" })
		vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
		-- stylua: ignore end
	end,
}
