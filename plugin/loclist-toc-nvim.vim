if exists('g:loaded_loclist_toc_nvim') | finish | endif

let s:user_cpo = &cpo
set cpo&

autocmd FileType markdown nnoremap <buffer> <silent> <leader>tt :lua require('loclist-toc-nvim').make_loclist_toc()<cr>

let &cpo = s:user_cpo
unlet s:user_cpo

let g:loaded_loclist_toc_nvim = 1
