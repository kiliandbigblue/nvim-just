local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")

local M = {}

function M.JustSelect(opts)
	opts = opts or {}
	local justfile_path = opts.justfile or "/Users/kiliandemeulemeester/projects/cli/justfile"

	-- Get Just recipes
	local command = string.format("just --justfile %s --summary", justfile_path)
	local output = vim.fn.systemlist(command)

	pickers
		.new(opts, {
			prompt_title = "Just Recipes",
			finder = finders.new_table({
				results = vim.split(output[1], "%s+"),
			}),
			sorter = conf.generic_sorter(opts),
			attach_mappings = function(prompt_bufnr, _)
				actions.select_default:replace(function()
					actions.close(prompt_bufnr)
					local selection = action_state.get_selected_entry()[1]
					vim.cmd(string.format("Just %s", selection))
				end)
				return true
			end,
		})
		:find()
end

return M
