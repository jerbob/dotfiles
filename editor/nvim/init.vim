"                            vim:foldmethod=marker
"                  ~ https://github.com/AnonGuy/Dotfiles ~

" General Options {{{
set nowrap
set hidden
set mouse=a
set nobackup
set smartcase
set noshowmode
set splitright
set splitbelow
set guicursor=
set foldlevel=99
set shortmess+=c
set nowritebackup
set termguicolors
set updatetime=300
set signcolumn=yes
set updatetime=500
set encoding=utf-8
set foldmethod=indent
set laststatus=2 ruler
set number norelativenumber

" Resize window ratios automagically
autocmd VimResized * wincmd =

" Disable some things on terminal windows
autocmd TermOpen * set nonu
autocmd TermOpen * set signcolumn=no
autocmd TermOpen * let g:indentLine_enabled = 0

" Tab Configuration
set softtabstop=2 tabstop=2 shiftwidth=2 expandtab
autocmd Filetype python setlocal ts=4 sw=4 sts=0
autocmd Filetype java setlocal ts=4 sw=4 sts=0
autocmd Filetype html setlocal ts=2 sw=2 sts=0
autocmd Filetype go setlocal ts=4 sw=4 sts=0
" }}}


" Keyboard Shortcuts and remaps {{{
nnoremap <space> za
nnoremap <C-Tab> :bn<CR>
nnoremap <C-S-Tab> :bp<CR>
nnoremap <C-g> :GitMessenger<CR>
nnoremap <Leader>h :Hexmode <CR>
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>

" Toggle search highlights
nnoremap <silent><expr> <Leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" Toggle the NERDTree sidebar
map <F6> :NERDTreeToggle<CR>
" Toggle the ctags viewer
map <F7> :Tagbar<CR>
map <C-f> :CtrlP<CR>

set clipboard=unnamed,unnamedplus

" Escape out of nested term:// things
tnoremap <Esc> <C-\><C-n>

" FZF fuzzy tag finder
nnoremap <silent> <C-t> :Tags<CR>

" Floating window
" Don't really use tags but this snippet is cool regardless
let $FZF_DEFAULT_OPTS='--layout=reverse'
let g:fzf_layout = { 'window': 'call FloatingFZF()' }
let g:fzf_tags_command = 'ctags -R %:p:h'
function! FloatingFZF()
  let buf = nvim_create_buf(v:false, v:true)
  call setbufvar(buf, '&signcolumn', 'no')
  let height = 10
  let width = float2nr(&columns - (&columns * 2 / 4))
  let col = float2nr((&columns - width) / 2)
  let opts = {
        \ 'relative': 'editor',
        \ 'row': 1,
        \ 'col': col,
        \ 'width': width,
        \ 'height': height
        \ }
  call nvim_open_win(buf, v:true, opts)
endfunction
" }}}


" Plugins {{{

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if &compatible
  set nocompatible
endif

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  
  if executable('discord-canary') || executable('discord')
    " If this machine has a Discord client:
    call dein#add('aurieh/discord.nvim')
  endif

  call dein#add('Glench/Vim-Jinja2-Syntax')
  call dein#add('ap/vim-css-color')
  call dein#add('aserebryakov/vim-todo-lists')
  call dein#add('ctrlpvim/ctrlp.vim')
  call dein#add('jiangmiao/auto-pairs')
  call dein#add('majutsushi/tagbar')
  call dein#add('mhinz/vim-startify')
  call dein#add('neoclide/coc.nvim', {'merged':0, 'rev': 'release'})
  call dein#add('pseewald/vim-anyfold')
  call dein#add('scrooloose/nerdtree')
  call dein#add('itchyny/lightline.vim')
  call dein#add('vim-python/python-syntax')
  call dein#add('morhetz/gruvbox')
  call dein#add('junegunn/fzf', {'build': './install --bin'})
  call dein#add('junegunn/fzf.vim')
  call dein#add('chr4/nginx.vim')
  call dein#add('Yggdroot/indentLine')

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

" }}}


" Appearance {{{
syntax on
let g:lightline = {'colorscheme': 'gruvbox'}
let g:gruvbox_contrast_dark='hard'

colorscheme gruvbox
set background=dark
" }}}


" Plugin Configuration {{{
filetype plugin indent on

" Git shouldn't start nested nvim instances
if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete

" Map Tab completions for coc.nvim
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Add coc.nvim to status line
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

if has('conceal')
  set conceallevel=0 concealcursor=niv
endif

let g:python_highlight_all = 1
let g:airline#extensions#tabline#enabled = 1

" Some fonts don't play nice with indentLine
let g:indentLine_char = '|'

" Gruvbox high contrast
let g:gruvbox_contrast_dark = 'hard'

" Anyfold configuration
autocmd Filetype * AnyFoldActivate
" }}}

" Behaviour Settings {{{
try
  " Allow persistent undo 
  set undodir=/tmp/$USER/vim_undo
  set undofile
catch
endtry

" Jump to last location when file is opened
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }}}
