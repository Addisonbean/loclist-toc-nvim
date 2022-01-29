# loclist-toc-nvim

Generates a table of contents in your location list for markdown files.

## Usage

Put something like this in your `vimrc`

```
autocmd FileType markdown nnoremap <buffer> <silent> <leader>tt :lua require('loclist-toc-nvim').make_markdown_toc()<cr>
```

or like this in your `init.vim`

```
vim.cmd [[autocmd FileType markdown nnoremap <buffer> <silent> <leader>tt :lua require('loclist-toc-nvim').make_markdown_toc()<cr>]]
```
