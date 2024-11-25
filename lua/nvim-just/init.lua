local M = {}

function M.setup(opts)
	opts = opts or {}
	local justfile_path = opts.justfile

	vim.api.nvim_create_user_command("Just", function(cmd_opts)
		local buf = vim.api.nvim_create_buf(false, true)

		local cmd = "just --justfile " .. justfile_path .. " " .. table.concat(cmd_opts.fargs, " ")

		local width = vim.api.nvim_get_option("columns")
		local height = vim.api.nvim_get_option("lines")

		local win_width = math.floor(width * 0.8)
		local win_height = math.floor(height * 0.8)

		local win = vim.api.nvim_open_win(buf, true, {
			relative = "editor",
			width = win_width,
			height = win_height,
			col = math.floor((width - win_width) / 2),
			row = math.floor((height - win_height) / 2),
			style = "minimal",
			border = "rounded",
		})

		vim.fn.termopen(cmd, {
			on_exit = function(_, code)
				vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", { noremap = true, silent = true })
			end,
		})

		vim.cmd("startinsert")
	end, {
		nargs = "*",
		complete = "file",
	})
end

return M
