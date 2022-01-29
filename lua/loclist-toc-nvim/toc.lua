local config = require('loclist-toc-nvim.config')

local function shallowcopy(t)
	local new_t = {}
	for k,v in ipairs(t) do
		new_t[k] = v
	end
	return new_t
end

local function get_heading_level(line)
	return line:match('^#+'):len()
end

local function get_heading(line)
	return line:match('^#+%s*([^#]+)%s*#*')
end

local function format_loclist_entry(info)
	local items = vim.fn.getloclist(0, { items = 0 }).items

	local lines = {}
	for _, item in ipairs(items) do
		table.insert(lines, item.text)
	end

	return lines
end

local function make_loclist_toc()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

	-- TODO: stop using `level` to mean both depth and which markdown heading
	local loc_items = {}
	local prev_level = 0
	local levels = {}
	local entries = {}
	for line_number, line in ipairs(lines) do
		local heading = get_heading(line)
		if heading ~= nil then
			local heading_level = get_heading_level(line)

			if heading_level < prev_level then
				local diff = prev_level - heading_level
				for _ = 1, diff do
					table.remove(levels)
				end

				levels[#levels] = levels[#levels] + 1
			elseif heading_level > prev_level then
				table.insert(levels, 1)
			else
				levels[#levels] = levels[#levels] + 1
			end

			table.insert(entries, {
				text = heading,
				line_number = line_number,
				depth = shallowcopy(levels),
				level = heading_level,
			})

			prev_level = heading_level
		end
	end

	local bufnr = vim.fn.bufnr('%')

	local formatted_entries = config.format_entries(entries)
	local results = {}
	for i, entry in ipairs(entries) do
		table.insert(results, {
			text = formatted_entries[i],
			lnum = entry.line_number,
			col = 1,
			bufnr = bufnr,
		})
	end

	vim.fn.setloclist(0, {}, ' ', { efm = '%f', items = results, quickfixtextfunc = format_loclist_entry, title = 'Table of Contents' })
	vim.cmd('lopen')
end

return {
	make_loclist_toc = make_loclist_toc,
}
