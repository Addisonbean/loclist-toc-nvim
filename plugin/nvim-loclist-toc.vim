if exists('g:loaded_nvim_loclist_toc') | finish | endif

let s:user_cpo = &cpo
set cpo&

autocmd FileType markdown nnoremap <buffer> <silent> <leader>tt :lua require('nvim-loclist-toc').make_loclist_toc()<cr>

let &cpo = s:user_cpo
unlet s:user_cpo

let g:loaded_nvim_loclist_toc = 1
