" *****************************************
"     Vundle Setup
" *****************************************
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" Color scheme
Plugin 'altercation/vim-colors-solarized'

" VIM IDE Plugins
Plugin 'vim-scripts/vim-auto-save'
let g:auto_save = 1
Plugin 'ervandew/supertab'
Plugin 'jeffkreeftmeijer/vim-numbertoggle'
Plugin 'vim-scripts/tComment'
Plugin 'moll/vim-bbye'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-abolish'
Plugin 'tpope/vim-repeat'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Yggdroot/indentLine'
Plugin 'skwp/greplace.vim'
Plugin 'sandeepcr529/Buffet.vim'
Plugin 'scrooloose/nerdtree'
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
Plugin 'djoshea/vim-autoread'
Plugin 'tommcdo/vim-exchange'
Plugin 'rking/ag.vim'

" VIM external integration plugins
Plugin 'tpope/vim-fugitive'
 
" Coding Plugins
Plugin 'slim-template/vim-slim.git'
Plugin 'tpope/vim-rails'
Plugin 'vim-ruby/vim-ruby'
Plugin 'tpope/vim-haml'
Plugin 'kchmck/vim-coffee-script'
Plugin 'tpope/vim-endwise'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'majutsushi/tagbar'
Plugin 'tpope/vim-bundler'
" Plugin 'szw/vim-tags' This plugin is causing the dependencies are satisfied

" Ruby Static Analyser
Plugin 'ngmy/vim-rubocop'
Plugin 'rainerborene/vim-reek'

" Fun plugin
Plugin 'koron/nyancat-vim'
Plugin 'stevearc/vim-arduino'
let g:arduino_cmd = '/Users/stevenyap/Applications/Arduino.app/Contents/MacOS/Arduino'
let g:arduino_serial_port = '/dev/cu.usbmodem1411'
let g:arduino_serial_cmd = 'picocom {port} -b {baud} -l'
let g:arduino_programmer = ''

" Tmux integration for rspec testing
Plugin 'tpope/vim-dispatch'
Plugin 'jgdavey/tslime.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'thoughtbot/vim-rspec'
let g:rspec_command = "Dispatch rspec -I . --color -f p {spec}"
" let g:rspec_command = 'call Send_keys_to_Tmux("Enter") | call Send_to_Tmux("rspec -I . -c {spec}\n")'
" RSpec.vim mappings
autocmd FileType qf setlocal wrap linebreak 

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Colorscheme (based on altercation/vim-colors-solarized)
set t_Co=256
syntax on
set background=light
colorscheme solarized

" *****************************************
"     Vim Settings
" *****************************************

runtime macros/matchit.vim

set wildmenu
set wildmode=full

set switchbuf=useopen,usetab,split

set history=500
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
set pastetoggle=<F2>

" Make VIM run fast even in large long lines files
set synmaxcol=150

" Make backspace works like normal
set backspace=indent,eol,start

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Lower timeout for mappings (faster response)
set ttimeout
set timeout timeoutlen=300 ttimeoutlen=300

" Set markdown syntax highlight
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.md set wrap linebreak

" Don't add the comment prefix when I hit enter or o/O on a comment line.
set formatoptions-=or

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

let mapleader = " "

" Rspec
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" Deploy Arduino runner.rb in current directory
map <Leader>d :Dispatch ruby %%/runner.rb<CR>

" open buffet list
map <Leader>b :Bufferlist<cr>

" Quickfix windows open and close
map <Leader>qq :cclose<CR>
map <Leader>qf :copen<CR>

" split lines above
map <Leader>K i<cr><esc><up>:m +1<cr> 

" split lines below
map <Leader>k i<cr><esc> 

" opens NerdTree
map <Leader>n :NERDTreeToggle<CR> 

" opens Tagbar
map <Leader>m :TagbarToggle<CR>

" closes current buffet
map <Leader>x :Bdelete<cr>

" close the next window
map <Leader>X <c-w><c-w>:q<CR>

" reloads $MYVIMRC
map <Leader>r :so $MYVIMRC<cr>

" copies selected text into Mac OS clipboard
vmap <Leader>c :w !reattach-to-user-namespace pbcopy<cr><cr>:echo 'Copied to pbcopy'<cr>

" clear highlighted search
map <Leader>/ :nohlsearch<CR>

" convert ruby hash from :abc => '123' to abc: '123'
map <Leader>h :%s/:\([^=,'"]*\) =>/\1:/g"']<CR>

" Code format entire file
map <Leader>= ggVG=

" Compile coffeescript codes and show in a temporary buffer
map <Leader>p :CoffeeCompile<CR>
