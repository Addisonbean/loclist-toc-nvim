# loclist-toc-nvim

Generates a table of contents in your location list for markdown files.

Currently it only supports the `#` syntax for markdown headers, and it should support any format that has markdown-style headings.

## Setup

`require('loclist-toc-nvim').setup{}`

## Usage

 You can create a table of contents using `require('loclist-toc-nvim').make_markdown_toc()`. Here's an example how to bind that to a shortcut for all markdown files.

```lua
vim.cmd [[autocmd FileType markdown nnoremap <buffer> <silent> <leader>tt :lua require('loclist-toc-nvim').make_markdown_toc()<cr>]]
```

## Customizing

You can control how headings are displayed in the location list by passing a custom function to the `format_entries` key in `setup`.

That function will take a table/list of entries, each with the following information (they will be sorted by occurrence in the file):

```
{
	text, -- The content of the heading not including the beginning '#' chars
	line_number, -- Line number the heading was found on
	depth, -- a table/list containing where the heading was found in relation to previous headings, will be explained below in greater depth
	level, -- Which level of heading the markdown heading is (1-6)
}
```

The `depth` key is hard to explain so I'll give an example that will hopefully make it clear, but try to think of them as "section" indicators much like a table of contents might normally have.

```markdown
# depth = { 1 }
# depth = { 2 }
## depth = { 2, 1 }
### depth = { 2, 1, 1 }
### depth = { 2, 1, 2 }
## depth = { 2, 2 }
### depth = { 2, 2, 1 }
# depth = { 3 }
```

Here's an example of a pretty basic `format_entries` function that just makes the table of contents entries look like pretty normal markdown headers.

```lua
require('loclist-toc-nvim').setup{
  format_entries = function(entries)
    local lines = {}
    for _, e in ipairs(entries) do
      local line = string.rep('#', e.level) .. ' ' .. e.text
      table.insert(lines, line)
    end
    return lines
  end,
}
```

See the default implementation in [lua/loclist-toc-nvim/config.lua](https://github.com/Addisonbean/loclist-toc-nvim/blob/master/lua/loclist-toc-nvim/config.lua#L2) for another example.

## Todo

- Ignore lines in code blocks (as I learned testing this file...)
- Support the other style of markdown headings (with the `======` under the text)
- Tests
