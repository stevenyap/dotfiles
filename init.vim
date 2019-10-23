" Start declaring all Plugins
autocmd!
let g:loaded_python_provider = 1 " Turn off python2
call plug#begin('~/.nvim/plugged')

" Use solarized color scheme
Plug 'iCyMind/NeoSolarized'

" Read the file automatically when returning back to Vim
Plug 'djoshea/vim-autoread'

" Toggles between relative and absolute line numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Fuzzy file matching
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = 'ag --path-to-ignore ~/Workspace/dotfiles/.agignore --literal --files-with-matches --nocolor --hidden -g "" %s'

" Ag silver searcher plugin
Plug 'numkil/ag.nvim'
let g:ag_prg = 'ag --path-to-ignore ~/Workspace/dotfiles/.agignore --vimgrep --silent'

" Easy commenting in code (gcc)
Plug 'tpope/vim-commentary'

" Easy manipulation of enclosing brackets/etc (ysiw)
Plug 'tpope/vim-surround'

" dot operator repeat for vim-commentary/vim-surrond
Plug 'tpope/vim-repeat'

" Automatically close your brackets/etc
Plug 'jiangmiao/auto-pairs'
" Add back closing tag for jiangmiao/auto-pairs
let g:AutoPairsFlyMode = 0
let g:AutoPairsShortcutBackInsert = '<C-b>'

" Displays a | for indentation
Plug 'Yggdroot/indentLine'
let g:indentLine_char = '⁞'
let g:indentLine_color_term = 254 " Solarized base2 color 

" Nice status bar
Plug 'vim-airline/vim-airline'
" Disable all extensions for vim-airline for better performance
let g:airline_extensions=['ale']
let g:airline#extensions#ale#enabled = 1

" Displays directory file system on the side
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let NERDTreeIgnore=['node_modules', '.git$', '\.swp$', 'rethinkdb_data', '\.DS_Store$']

" Track IDE time in wakatime.com
Plug 'wakatime/vim-wakatime'

" Always need a nyan cat to unwind
Plug 'koron/nyancat-vim'

""" Language Server
" Linting
Plug 'dense-analysis/ale'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_lint_on_enter = 1
let g:ale_lint_on_filetype_changed = 1
let g:ale_lint_on_text_changed = 1
let g:ale_lint_on_save = 0
let g:ale_history_log_output = 1 " Type :ALEInfo to view and debug
let g:ale_javascript_eslint_executable = 'eslint_d'
let g:ale_elm_make_executable = 'elm-app' " Use local elm in create-elm-app
nmap <silent> gk <Plug>(ale_previous_wrap) " Jump to previous error
nmap <silent> gj <Plug>(ale_next_wrap) " Jump to next error

" Code Formatting
Plug 'sbdchd/neoformat'
" Use eslint_d to fix format
" Use eslint-prettier to fix format through eslint_d
let g:neoformat_enabled_javascript = ['eslint_d']

" Auto-completion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup = 1
" Map navigation & Enter in insert mode for deoplete auto-completion
inoremap <expr><C-j> pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><C-k> pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr><CR>  pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"

" Syntax highlighting and indentation for JSON
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

" Syntax highlighting and indentation for Javascript
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
let g:javascript_plugin_flow = 1

" Plugin for Elm development
Plug 'Zaptic/elm-vim', { 'for': 'elm' }
let g:elm_setup_keybindings = 0

" Initialize plugin system
call plug#end()

" *****************************************
"     Vim Settings
" *****************************************

" Color scheme
set background=light
colorscheme NeoSolarized

" Set highlighting for ALE
highlight ALEErrorSign ctermbg=DarkRed ctermfg=White
highlight ALEWarningSign ctermbg=Brown ctermfg=White

set wildmenu
set wildmode=full
set switchbuf=useopen,usetab
set history=500
set splitbelow
set splitright
set number
set cursorline
set hlsearch
set incsearch
set nowrap
set showcmd
set autowriteall

" Set the folding behaviors
set foldmethod=syntax
set nofoldenable

" Yanks text into system clipboard
set clipboard=unnamed

" Make backspace works like normal
set backspace=indent,eol,start

" Softtabs, 2 spaces
set tabstop=2
set shiftwidth=2
set expandtab

" Lower timeout for mappings (faster response)
set ttimeout
set timeout timeoutlen=300 ttimeoutlen=300

" Live preview of subsitution
set inccommand=split

" Faster escape in insert mode
autocmd InsertEnter * set timeoutlen=0 ttimeoutlen=0
autocmd InsertLeave * set timeoutlen=300 ttimeoutlen=300

" Set markdown syntax highlight
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.md set wrap linebreak

" Turn on autoformatting from NeoFormat plugin
autocmd BufWritePre *.js Neoformat

" Saves undo into a file and use it across all vim sessions
set undodir=~/.nvim/undo
set undofile

" Set formatting for python
autocmd BufNewFile,BufRead *.py set tabstop=4
autocmd BufNewFile,BufRead *.py set shiftwidth=4

" *****************************************
"     Personal Key mapping
" *****************************************

" Auto-expand %% to the current file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Navigation around windows
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <tab><tab> <c-w><c-w>

" Move lines in normal, visual and insert modes
" ∆ is <A-j>
" ˚ is <A-k>
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" Insert a line break above
nmap K 0i<cr><esc>

" *****************************************
"     Leader Mappings
" *****************************************

let mapleader = " "

" Save the file
nnoremap <Leader>s :w<CR>

" Quickfix windows open and close
map <Leader>qq :cclose<CR>
map <Leader>qf :copen<CR>

" Split lines below
map <Leader>k i<cr><esc>

" Opens NerdTree
map <Leader>n :NERDTreeToggle<CR>

" Clear highlighted search
map <Leader>/ :nohlsearch<CR>

" Toggle paste and nopaste mode
nnoremap <Leader>p :set invpaste paste?<CR>

" Displays the registers
map <Leader>r :reg<CR>

" Yank the whole page
map <Leader>y mcggVGy`c

" vim-elm key-bindings
map <Leader>w :ElmBrowseDocs<CR>
map <Leader>d :ElmShowDocs<CR>
map <Leader>e :ALEDetail<CR>
