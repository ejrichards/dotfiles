return {
	"nvim-lualine/lualine.nvim",
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		sections = {
			lualine_b = {
				function()
					if vim.env.GIT_DIR ~= nil and vim.env.GIT_WORK_TREE ~= nil then
						return "Baredot"
					end
					return ""
				end,
				function()
					local workspace_name = require("workspaces").name()
					if workspace_name == nil then
						return ""
					end

					return workspace_name
				end,
				"branch",
				"diff",
				"diagnostics",
			},
			lualine_c = {
				"filename",
				{
					require("noice").api.status.search.get,
					cond = require("noice").api.status.search.has,
					color = { fg = "#ff9e64" },
				},
			},
			lualine_x = {
				-- '%S',
				{
					require("noice").api.status.mode.get,
					cond = require("noice").api.status.mode.has,
					color = { fg = "#ff9e64" },
				},
				"encoding",
				"fileformat",
				"filetype",
			},
		},
	},
}
