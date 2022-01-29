local config = {
	format_entries = function(entries)
		local max_len = 0
		for _, e in ipairs(entries) do
			local formatted_level = ''
			for _, l in ipairs(e.depth) do
				formatted_level = formatted_level .. tostring(l) .. '.'
			end

			-- Remove trailing '.' from `displayed_level`
			formatted_level = formatted_level:sub(1, -2)

			e.formatted_level = formatted_level
			max_len = math.max(max_len, #formatted_level)
		end

		local lines = {}
		for _, e in ipairs(entries) do
			local padding = string.rep(' ', max_len - #e.formatted_level + 1)

			local s = e.formatted_level .. padding .. e.text
			table.insert(lines, s)
		end

		return lines
	end
}

return config
