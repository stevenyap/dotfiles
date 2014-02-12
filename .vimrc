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
Bundle 'tpope/vim-fugitive'
 
Bundle 'bling/vim-airline'
" let g:airline#extensions#tabline#enabled = 1
let g:airline_theme = 'bubblegum'
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline_powerline_fonts = 1
let g:airline_section_x = ''
let g:airline_section_y = ''
let g:airline_section_z = '%l:%c'

Bundle 'mhinz/vim-signify'
let g:signify_vcs_list = [ 'git' ]
let g:signify_update_on_bufenter = 1
let g:signify_update_on_focusgained = 1
autocmd CursorHold,InsertLeave * if exists('b:sy') | call sy#start(b:sy.path) | endif
autocmd ColorScheme * highlight clear SignColumn

" Coding Bundles
Bundle 'tpope/vim-rails'
Bundle 'szw/vim-tags'
let g:vim_tags_gems_tags_command = "ctags -R {OPTIONS} `bundle show --paths` 2>/dev/null"

Bundle 'jeffkreeftmeijer/vim-numbertoggle'
Bundle 'vim-scripts/tComment'
Bundle 'moll/vim-bbye'
Bundle 'kien/ctrlp.vim'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-repeat'
Bundle 'jiangmiao/auto-pairs'
Bundle 'Yggdroot/indentLine'

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
autocmd FileType qf setlocal wrap linebreak 

" Colorscheme
Bundle 'altercation/vim-colors-solarized'
syntax on
set background=light
colorscheme solarized

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

" Matcher tab settings
set wildmenu
set wildmode=full

set grepprg=ack
set switchbuf=useopen,usetab,split

set history=100
set splitbelow
set splitright
set number
set numberwidth=4
set cursorline
set hlsearch
set incsearch
set nowrap
set showcmd
set laststatus=2

" Make VIM run fast even in large long lines files
set synmaxcol=128

" Make backspace works like normal
set backspace=indent,eol,start

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Lower timeout for mappings (faster response)
set ttimeout
set timeout timeoutlen=300 ttimeoutlen=300

" *****************************************
"     Personal Key mapping
" *****************************************

" Insert a line break above
nmap K 0i<cr><esc>

" Navigate around methods
nmap gm ]m
nmap gn [m

" Auto-expand %% to the current file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%' 

" Navigation around windows
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>

" Shift-Enter to escape in Insert Mode
inoremap <S-CR> <Esc> 

" *****************************************
"     Leader Mappings
" *****************************************

" Rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Quickfix windows open and close
map <Leader>qq :cclose<CR>
map <Leader>qf :copen<CR>

" split lines above
map <Leader>K i<cr><esc><up>:m +1<cr> 

" split lines below
map <Leader>k i<cr><esc> 

" opens NerdTree
map <Leader>n :NERDTreeToggle<CR> 

" closes current buffet
map <Leader>x :Bdelete<cr>

" reloads $MYVIMRC
map <Leader>r :so $MYVIMRC<cr>

" copies selected text into Mac OS clipboard
vmap <Leader>c :w !reattach-to-user-namespace pbcopy<cr><cr>:echo 'Copied to pbcopy'<cr>

" clear highlighted search
map <Leader>/ :nohlsearch<CR>
