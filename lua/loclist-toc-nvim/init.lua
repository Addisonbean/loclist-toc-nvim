local toc = require('loclist-toc-nvim.toc')
local config = require('loclist-toc-nvim.config')

local M = {}

M.setup = function(options)
	if options.format_entries ~= nil then
		config.format_entries = options.format_entries
	end
end

M.make_markdown_toc = toc.make_loclist_toc

return M
