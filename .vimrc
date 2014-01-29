set nocompatible
let mapleader = " "
runtime macros/matchit.vim
 
" Use vundle
set t_Co=256
filetype off                  " required!
filetype plugin indent on     " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()
Bundle 'gmarik/vundle'
 
" VIM-interface Bundles
Bundle 'vim-scripts/vim-auto-save'
let g:auto_save = 1

Bundle 'scrooloose/nerdtree'
Bundle 'jistr/vim-nerdtree-tabs'

Bundle 'bling/vim-airline'
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'luna'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1

Bundle 'tpope/vim-fugitive'
set statusline=%<%f\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P

Bundle 'airblade/vim-gitgutter'
autocmd ColorScheme * highlight clear SignColumn
let g:gitgutter_sign_column_always = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_escape_grep = 1
let g:gitgutter_realtime = 1
let g:gitgutter_eager = 0

" Coding Bundles
Bundle 'tpope/vim-rails'
Bundle 'szw/vim-tags'
let g:vim_tags_gems_tags_command = "ctags -R {OPTIONS} `bundle show --paths` 2>/dev/null"

Bundle 'jeffkreeftmeijer/vim-numbertoggle'
Bundle 'vim-scripts/tComment'
Bundle 'moll/vim-bbye'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-surround'
Bundle 'jiangmiao/auto-pairs'

" filetype indent plugin on
Bundle 'kana/vim-textobj-user'
Bundle 'nelstrom/vim-textobj-rubyblock'

" Snipmate
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "garbas/vim-snipmate"
Bundle "honza/vim-snippets"

" Tmux integration for rspec testing
Bundle 'tpope/vim-dispatch'
Bundle 'jgdavey/tslime.vim'
Bundle 'christoomey/vim-tmux-navigator'
Bundle 'thoughtbot/vim-rspec'
" let g:rspec_command = 'call Send_keys_to_Tmux("Enter") | call Send_to_Tmux("rspec -I . -c {spec}\n")'
let g:rspec_command = "Dispatch rspec -I . --format NyanCatFormatter --color {spec}"
" RSpec.vim mappings
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>
map <Leader>q :ccl<CR>

" VIM Settings
Bundle 'altercation/vim-colors-solarized'
syntax on
set background=dark
colorscheme solarized
set guioptions-=m  "remove menu bar
set guioptions-=T  "remove toolbar
set guioptions-=r  "remove right-hand scroll bar
set guioptions-=L  "remove left-hand scroll bar

" Auto-completion + tabbing
filetype plugin on
au FileType php setl ofu=phpcomplete#CompletePHP
au FileType ruby,eruby setl ofu=rubycomplete#Complete
au FileType html,xhtml setl ofu=htmlcomplete#CompleteTags
au FileType c setl ofu=ccomplete#CompleteCpp
au FileType css setl ofu=csscomplete#CompleteCSS
set completeopt=longest,menuone
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <expr> <C-n> pumvisible() ? '<C-n>' : '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
inoremap <expr> <M-,> pumvisible() ? '<C-n>' : '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'
" open omni completion menu closing previous if open and opening new menu without changing the text
inoremap <expr> <C-Space> (pumvisible() ? (col('.') > 1 ? '<Esc>i<Right>' : '<Esc>i') : '') .  '<C-x><C-o><C-r>=pumvisible() ? "\<lt>C-n>\<lt>C-p>\<lt>Down>" : ""<CR>'
" open user completion menu closing previous if open and opening new menu without changing the text
inoremap <expr> <S-Space> (pumvisible() ? (col('.') > 1 ? '<Esc>i<Right>' : '<Esc>i') : '') .  '<C-x><C-u><C-r>=pumvisible() ? "\<lt>C-n>\<lt>C-p>\<lt>Down>" : ""<CR>'
Bundle 'ervandew/supertab'

set grepprg=ack
set switchbuf=usetab,newtab
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
inoremap jj <ESC>

set splitbelow
set splitright
set number
set numberwidth=4
set hlsearch
set nowrap
set showcmd
set laststatus=2

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" " Personal Key mapping
nmap K i<cr><esc>k$ " makes K split lines (the opposite of J).
