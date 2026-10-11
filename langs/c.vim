" ---------------------------
" C/C++ Development
" ---------------------------

" C/C++ compiler and debug shortcuts
nnoremap <buffer> <leader>cc :!gcc -Wall -g % -o %:r<CR>
nnoremap <buffer> <leader>cr :!./%:r<CR>
nnoremap <buffer> <leader>cpp :!g++ -std=c++17 -Wall -g % -o %:r<CR>
nnoremap <buffer> <leader>cpr :!./%:r<CR>

" C/C++ syntax enhancements
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_posix_standard = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

" ---------------------------
" Linting & formatting (ALE)
" Diagnostik C/C++ datang dari coc-clangd (LSP), jadi ALE tidak menjalankan
" linter C sendiri (menghindari dua clangd dan gcc tiap jeda mengetik).
" Formatting saat save hanya lewat ALE (clang-format), bukan FormatFile().
" ---------------------------
let g:ale_linters = get(g:, 'ale_linters', {})
let g:ale_linters['c'] = []
let g:ale_linters['cpp'] = []

let g:ale_fixers = get(g:, 'ale_fixers', {})
let g:ale_fixers['c'] = ['clang-format']
let g:ale_fixers['cpp'] = ['clang-format']
let g:ale_c_clangformat_options = '-style=file'
let g:ale_cpp_clangformat_options = '-style=file'
let g:ale_fix_on_save = 1

" Linting saat mengetik dimatikan untuk semua filetype (ShellCheck tetap jalan saat save)
let g:ale_lint_on_text_changed = 'never'
let g:ale_lint_on_insert_leave = 0

" C headers are C in this project
autocmd BufRead,BufNewFile *.h setlocal filetype=c

" Filetype specific settings
autocmd FileType c setlocal commentstring=//\ %s
autocmd FileType c setlocal shiftwidth=2 tabstop=2

autocmd FileType cpp setlocal commentstring=//\ %s
autocmd FileType cpp setlocal shiftwidth=2 tabstop=2
