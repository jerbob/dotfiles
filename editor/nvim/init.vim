"                            vim:foldmethod=marker
"                  ~ https://github.com/AnonGuy/Dotfiles ~
"
" General Options {{{
set nowrap
set hidden
set nospell
set mouse=a
set noruler
set nobackup
set smartcase
set noshowmode
set splitright
set splitbelow
set guicursor=
set foldlevel=99
set nowritebackup
set termguicolors
set shortmess=WFaoOAcI

set laststatus=0
set signcolumn=no
set conceallevel=0
set updatetime=500
set encoding=utf-8
set number norelativenumber

" Resize window ratios automagically
autocmd VimResized * wincmd =

" Disable some things on terminal windows
autocmd TermOpen * set nonu
autocmd TermOpen * set signcolumn=no

let g:indentLine_enabled = 0
autocmd BufReadPre,FileReadPre * :IndentLinesEnable

" Tab Configuration
set softtabstop=2 tabstop=2 shiftwidth=2 expandtab
autocmd Filetype python,java setlocal ts=4 sw=4 sts=0
autocmd Filetype html setlocal ts=2 sw=2 sts=0
autocmd Filetype go,cs setlocal ts=4 sw=4 sts=0
autocmd FileType pdc,md set conceallevel=0
autocmd FileType zsh set foldlevel=0
autocmd FileType gitcommit,gitrebase,gitconfig set bufhidden=delete
" }}}


" Keyboard Shortcuts and remaps {{{
nnoremap <space> za
nnoremap <C-m> :CtrlPMRUFiles<CR>
nnoremap <C-S-Tab> :bp<CR>
nnoremap <C-g> :GitMessenger<CR>
nnoremap <Leader>h :Hexmode <CR>
nnoremap <Leader>e :e <C-R>=expand('%:p:h') . '/'<CR>

command W w

" Toggle search highlights
nnoremap <silent><expr> <Leader>h (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n"

" Toggle the NERDTree sidebar
map <F6> :NERDTreeToggleVCS<CR>

" Activate ripgrep search
map <C-f> :Rg<CR>

set clipboard=unnamed,unnamedplus

" Escape out of nested term:// things
tnoremap <Esc> <C-\><C-n>

" FZF fuzzy tag finder
nnoremap <silent> <C-t> :Tags<CR>
" }}}


" Plugins {{{

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

if &compatible
  set nocompatible
endif

call plug#begin()

Plug 'tpope/vim-unimpaired'
Plug 'gcmt/taboo.vim'
Plug 'itchyny/lightline.vim'
Plug 'samoshkin/vim-mergetool'
Plug 'ekalinin/Dockerfile.vim'
Plug 'vim-pandoc/vim-pandoc'
Plug 'vim-pandoc/vim-pandoc-syntax'
Plug 'Glench/Vim-Jinja2-Syntax'
Plug 'ap/vim-css-color'
Plug 'chenillen/jad.vim'
Plug 'thaerkh/vim-workspace'
Plug 'aserebryakov/vim-todo-lists'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'majutsushi/tagbar'
Plug 'neoclide/coc.nvim'
Plug 'pseewald/vim-anyfold'
Plug 'scrooloose/nerdtree'
Plug 'sheerun/vim-polyglot'
Plug 'morhetz/gruvbox'
Plug 'junegunn/fzf',
Plug 'junegunn/fzf.vim',
Plug 'chr4/nginx.vim'
Plug 'Yggdroot/indentLine'
Plug 'xolox/vim-session'
Plug 'xolox/vim-misc'
Plug 'OmniSharp/omnisharp-vim'
Plug 'isobit/vim-caddyfile'

call plug#end()

" }}}


" Appearance {{{
syntax on
let g:lightline = {'colorscheme': 'gruvbox'}
let g:gruvbox_contrast_dark='hard'

colorscheme gruvbox
set background=dark
set guifont=Dank\ Mono:h30
" }}}


" Plugin Configuration {{{
filetype plugin indent on

let g:fzf_history_dir = '~/.local/share/fzf-history'

set sessionoptions+=tabpages,globals
let $FZF_DEFAULT_OPTS="--color=dark --layout=reverse --margin=1,1"
let $FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard || fd --type f --type l --hidden --follow"

function! s:build_quickfix_list(lines)
  call setqflist(map(copy(a:lines), '{ "filename": v:val }'))
  copen
  cc
endfunction

let g:fzf_action = {
  \ 'ctrl-q': function('s:build_quickfix_list'),
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }


" Git shouldn't start nested nvim instances
if has('nvim')
  let $GIT_EDITOR = 'nvr -cc split --remote-wait'
endif

" Don't autosave/load default editing session
let g:session_autosave = 'no'
let g:session_autoload = 'no'

" Ignore NERDTree when loading workspace
let g:workspace_autosave_ignore = ['nerdtree']

" NERDTree git plugin symbols
let g:NERDTreeIndicatorMapCustom = {
    \ "Modified"  : "~",
    \ "Staged"    : "+",
    \ "Untracked" : "*",
    \ "Renamed"   : "r",
    \ "Unmerged"  : "u",
    \ "Deleted"   : "-",
    \ "Dirty"     : "~",
    \ "Clean"     : "c",
    \ 'Ignored'   : 'i',
    \ "Unknown"   : "?"
    \ }

" Map Tab completions for coc.nvim
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

nmap <leader>rn <Plug>(coc-rename)
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Add coc.nvim to status line
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

if has('conceal')
  set conceallevel=0 concealcursor=niv
endif

let g:NERDTreeMinimalUI = 1
let g:NERDTreeMinimalMenu = 1
let g:python_highlight_all = 1
let g:airline#extensions#tabline#enabled = 1

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

" Show substitutions as they are being typed
set inccommand=nosplit

" Jump to last location when file is opened
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
" }}}
