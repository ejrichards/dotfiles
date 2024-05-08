local M = {}

-- Modified from ahmedkhalf/project.nvim
local function in_home_not_git()
	local search_dir = vim.fn.getcwd()
	local home = vim.env.HOME
	if vim.fn.has("win32") > 0 then
		search_dir = search_dir:gsub("\\", "/")
		home = home:gsub("\\", "/")
	end

	local last_dir_cache = ""
	local curr_dir_cache = {}

	local function get_parent(path)
		path = path:match("^(.*)/")
		if path == "" then
			path = "/"
		end
		return path
	end

	local function get_files(file_dir)
		last_dir_cache = file_dir
		curr_dir_cache = {}

		local dir = vim.loop.fs_scandir(file_dir)
		if dir == nil then
			return
		end

		while true do
			local file = vim.loop.fs_scandir_next(dir)
			if file == nil then
				return
			end

			table.insert(curr_dir_cache, file)
		end
	end

	local function has(dir, pattern)
		if last_dir_cache ~= dir then
			get_files(dir)
		end
		for _, file in ipairs(curr_dir_cache) do
			if file:match(pattern) ~= nil then
				return true
			end
		end
		return false
	end


	while true do
		if search_dir == home then
			return true
		end

		local pattern = "%.git"
		if has(search_dir, pattern) then
			return false
		end

		local parent = get_parent(search_dir)
		if parent == nil or parent == search_dir then
			return false
		end


		search_dir = parent
	end
end

local function set_dotmode(enable)
	if enable then
		vim.env.GIT_WORK_TREE = vim.fn.expand("~")
		vim.env.GIT_DIR = vim.fn.expand("~/.dotgit")
	else
		vim.env.GIT_WORK_TREE = nil
		vim.env.GIT_DIR = nil
	end
end

local function toggle_dotmode()
	if vim.env.GIT_DIR == nil or vim.env.GIT_WORK_TREE == nil then
		set_dotmode(true)
		print('Git in "dot" mode')
	else
		set_dotmode(false)
		print('Git in normal mode')
	end
end

function M.setup()
	local desc = 'Toggle using "~/.dotgit"'
	vim.keymap.set('n', '<leader>gg', toggle_dotmode, { desc = desc })

	if in_home_not_git() then
		set_dotmode(true)
	end

	local group = vim.api.nvim_create_augroup('autodot', { clear = true })
	vim.api.nvim_create_autocmd('DirChanged', {
		group = group,
		desc = desc,
		callback = function()
			if vim.v.event.scope == 'global' then
				set_dotmode(in_home_not_git())
			end
		end,
	})
end

return M
