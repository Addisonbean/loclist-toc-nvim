-- Next:
--   Alt headings
--   A way to do tests?
--   Alt ways to format the output

local function get_heading_level(line)
	return line:match('^#+'):len()
end

local function get_heading(line)
	return line:match('^#+%s*([^#]+)%s*#*')
end

local function format_loclist_entry(info)
	local items = vim.fn.getloclist(0, { items = 0 }).items

	local entries = {}
	local max_len = 1
	for idx = info.start_idx, info.end_idx do
		local heading = {}
		heading.level, heading.text = string.match(items[idx].text, '([%d.]+) (.+)')
		max_len = math.max(max_len, #heading.level)
		table.insert(entries, heading)
	end

	local formatted_entries = {}
	for _, e in ipairs(entries) do
		local s = e.level .. string.rep(' ', max_len - #e.level + 1) .. e.text
		table.insert(formatted_entries, s)
	end

	return formatted_entries
end

local function make_loclist_toc()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)

	local loc_items = {}
	local prev_level = 0
	local levels = {}
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

			local displayed_heading = ''
			for _, l in ipairs(levels) do
				displayed_heading = displayed_heading .. tostring(l) .. '.'
			end

			-- Remove trailing '.' from `displayed_heading`
			displayed_heading = displayed_heading:sub(1, -2) .. ' ' .. heading

			table.insert(loc_items, {
				bufnr = vim.fn.bufnr('%'),
				lnum = line_number,
				col = 1,
				text = displayed_heading,
			})

			prev_level = heading_level
		end
	end

	vim.fn.setloclist(0, {}, ' ', { efm = '%f', items = loc_items, quickfixtextfunc = format_loclist_entry, title = 'Table of Contents' })
	vim.cmd('lopen')
end

return {
	make_loclist_toc = make_loclist_toc,
}
