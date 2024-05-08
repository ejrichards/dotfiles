return {
	"ThePrimeagen/harpoon",
	-- Currenly and issue with :cd
	commit = "c6446e971f1a34c46deee1a22d06049ea2de0603",
	config = function()
		local extensions = require("harpoon.extensions");
		local harpoon = require("harpoon"):setup({
			settings = {
				save_on_toggle = true
			}
		});

		harpoon:extend(extensions.builtins.command_on_nav('UfoEnableFold'))

		vim.keymap.set("n", "<leader>a", function() harpoon:list():append() end, { desc = 'Harpoon Add' })
		vim.keymap.set("n", "<leader>j", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, { desc = 'Harpoon List' })
		vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
		vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
		vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
		vim.keymap.set("n", "<C-;>", function() harpoon:list():select(4) end)
	end
}
