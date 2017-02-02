" TODO: Set NeoVim installation in laptop repo once confirmed move to NeoVim
" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.nvim/plugged')

" *** Vim Plugs
" Use solarized color scheme
Plug 'altercation/vim-colors-solarized'

" Saves file automatically
Plug '907th/vim-auto-save'
let g:auto_save = 1

" Read the file automatically when returning back to Vim
Plug 'djoshea/vim-autoread'

" Displays a list of buffets
" <Leader>b to trigger
Plug 'sandeepcr529/Buffet.vim'

" Displays a menu of tagged functions via ctags
" <Leader>m to trigger
Plug 'majutsushi/tagbar'

" Displays directory file system on the side
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let NERDTreeIgnore=['node_modules', '.git$', '\.swp$', 'rethinkdb_data', '\.DS_Store$']

" Syntax highlighting
Plug 'scrooloose/syntastic'
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1
let g:syntastic_javascript_checkers = ['eslint', 'flow']
let g:syntastic_javascript_eslint_exec = 'eslint_d' " Faster syntax checking
let g:syntastic_json_checkers=['jsonlint']
let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'
" Requirement: npm install -g eslint eslint-config-standard eslint-plugin-import eslint-plugin-promise eslint-plugin-react eslint-plugin-standard

" Toggles between relative and absolute line numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Fuzzy file matching
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Ag silver searcher plugin
Plug 'rking/ag.vim'

" *** Coding Plugs
" TODO: Checkout the snippet plugin
" Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'

" Easy commenting in code (gcc)
Plug 'tpope/vim-commentary'

" Easy manipulation of enclosing brackets/etc (ysiw)
Plug 'tpope/vim-surround'

" dot operator repeat for vim-commentary/vim-surrond
Plug 'tpope/vim-repeat'

" Automatically close your brackets/etc
Plug 'jiangmiao/auto-pairs'

" Displays a | for indentation
Plug 'Yggdroot/indentLine'

" Nice status bar
Plug 'vim-airline/vim-airline'
" Only enable syntastic for better performance
let g:airline_extensions=['syntastic']

" *** HTML/CSS/JSON Plugs
" HTML tag expander
Plug 'mattn/emmet-vim'

" Syntax highlighting and indentation for JSON
Plug 'elzr/vim-json'
" Need the below config because of Yggdroot/indentLine
let g:indentLine_noConcealCursor=""

" *** Javascript Plugs
" Plugin for Javascript flow typing
" Can jump to definition directly without ctags
Plug 'flowtype/vim-flow', { 'for': 'javascript' }
let g:flow#enable = 0

" Syntax highlighting and indentation for Javascript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
let g:javascript_plugin_flow = 1

" Syntax highlighting and indentation for JSX
Plug 'mxw/vim-jsx', { 'for': 'javascript' }
let g:jsx_ext_required = 0

" *** Ruby Plugs
" Plugin for rails development
Plug 'tpope/vim-rails', { 'for': 'ruby' }

" *** Other Plugs
" Track IDE time in wakatime.com
Plug 'wakatime/vim-wakatime'

" Always need a nyan cat to unwind
Plug 'koron/nyancat-vim'

" Initialize plugin system
call plug#end()

" *****************************************
"     Vim Settings
" *****************************************

" Color scheme
set background=light
colorscheme solarized

set wildmenu
set wildmode=full
set switchbuf=useopen,usetab
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

" Set JSON filtype
autocmd BufRead,BufNewFile *.json set filetype=json

" JS with Flow shortcuts
" Require plugin flowtype/vim-flow
autocmd Filetype javascript nnoremap <C-]> :vsp<CR>:FlowJumpToDef<CR>zz

" *****************************************
"     Personal Key mapping
" *****************************************

" Insert a line break above
nmap K 0i<cr><esc>

" Auto-expand %% to the current file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Navigation around windows
nnoremap <c-l> <c-w>l
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <tab><tab> <c-w><c-w>
" Currently not working: https://github.com/neovim/neovim/issues/2048
" Hack is achieved via tmux conf
nnoremap <c-h> <c-w>h

" Shift-Enter to escape in Insert Mode
inoremap <S-CR> <Esc>

" *****************************************
"     Leader Mappings
" *****************************************

let mapleader = " "

" Open buffet list
map <Leader>b :Bufferlist<cr>

" Quickfix windows open and close
map <Leader>qq :cclose<CR>
map <Leader>qf :copen<CR>

" Split lines above
map <Leader>K i<cr><esc><up>:m +1<cr>

" Split lines below
map <Leader>k i<cr><esc>

" Opens NerdTree
map <Leader>n :NERDTreeToggle<CR>

" Opens Tagbar
map <Leader>m :TagbarToggle<CR>

" Close the next window
map <Leader>X <c-w><c-w>:q<CR>

" Yanks text into system clipboard
set clipboard=unnamed

" Clear highlighted search
map <Leader>/ :nohlsearch<CR>

" Convert ruby hash from :abc => '123' to abc: '123'
map <Leader>h :%s/:\([^=,'"]*\) =>/\1:/g"']<CR>

" Auto-format the entire current file
map <Leader>= ggVG=

" Toggle paste and nopaste mode
set pastetoggle=<leader>p
