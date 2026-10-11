" ---------------------------
" Universal Formatting Configuration
" ---------------------------

function! FormatFile()
  let l:filetype = &filetype

  " Web files use Neoformat with the configured Prettier formatter.
  if index(['javascript', 'typescript', 'javascriptreact', 'typescriptreact',
           \ 'html', 'css', 'json', 'markdown', 'yaml', 'yml'], l:filetype) >= 0
    execute 'Neoformat'

  " Shell scripts menggunakan shfmt
  elseif index(['sh', 'bash'], l:filetype) >= 0
    if executable('shfmt')
      execute 'Neoformat'
    else
      echo "shfmt not installed. Run: pkg install shfmt"
    endif

  " Python menggunakan black atau autopep8
  elseif l:filetype == 'python'
    if executable('black')
      execute '%!black -q -'
    elseif executable('autopep8')
      execute '%!autopep8 -'
    endif

  " Go menggunakan gofmt
  elseif l:filetype == 'go'
    if executable('gofmt')
      execute '%!gofmt'
    endif

  " C/C++ menggunakan clang-format
  elseif index(['c', 'cpp'], l:filetype) >= 0
    if executable('clang-format')
      execute '%!clang-format -style=file'
    endif

  " PHP menggunakan php-cs-fixer
  elseif l:filetype == 'php'
    if executable('php-cs-fixer')
      execute '!php-cs-fixer fix %'
    endif
  endif
endfunction

" Auto format on save untuk semua filetypes yang didukung
" Format saat save TIDAK berlaku untuk:
"   - Markdown: Prettier via Neoformat berjalan sebagai proses Node tiap save.
"               Format manual dengan <leader>fmt.
"   - C/C++:    ALE (clang-format) di langs/c.vim sudah menangani saat save.
autocmd BufWritePre *.js,*.ts,*.jsx,*.tsx,*.html,*.css,*.json,*.yaml,*.yml,*.sh,*.bash,*.py,*.go,*.php call FormatFile()

" Manual formatting command
command! -nargs=0 Format call FormatFile()
nnoremap <leader>fmt :Format<CR>
