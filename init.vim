" TODO: Set NeoVim installation in laptop repo once confirmed move to NeoVim
" TODO: Move .tmuxinator into dropbox for consistent replication of projects setup

" Clear all autocmd
autocmd!

" Specify a directory for plugins (for Neovim: ~/.local/share/nvim/plugged)
call plug#begin('~/.nvim/plugged')

" *** Vim Plugs
" Use solarized color scheme
Plug 'iCyMind/NeoSolarized'

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
Plug 'w0rp/ale'
let g:ale_set_loclist = 0
let g:ale_set_quickfix = 0
let g:ale_history_log_output = 1 " Type :ALEInfo to view and debug
let g:ale_statusline_format = ['⨉ %d', '⚠ %d', '⬥ ok']
let g:ale_linters = { 'javascript': ['eslint', 'flow'] }
let g:ale_lint_on_text_changed = 'always'
let g:ale_lint_on_save = 0
" eslint_d can only be used as global
let g:ale_javascript_eslint_use_global = 1
let g:ale_javascript_eslint_executable = 'eslint_d'
nmap <silent> gk <Plug>(ale_previous_wrap) " Jump to previous error
nmap <silent> gj <Plug>(ale_next_wrap) " Jump to next error

" Syntax formatting
Plug 'sbdchd/neoformat'
" Use eslint_d to fix format
" Use eslint-prettier to fix format through eslint_d
let g:neoformat_enabled_javascript = ['eslint_d']

" Toggles between relative and absolute line numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Fuzzy file matching
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Ag silver searcher plugin
Plug 'numkil/ag.nvim'

" Project-level fine-tuning of Vim
" index.ios.js: React Native projects
" package.json: Default Javascript projects
Plug 'tpope/vim-projectionist'
let g:projectionist_heuristics = {
      \   "src/*.js": {
      \     "src/*.js": {"alternate": "specs/{}.spec.js"},
      \     "specs/*.spec.js": {"alternate": "src/{}.js"},
      \   },
      \   "index.ios.js": {
      \     "app/*.js": {"alternate": "specs/{}.spec.js"},
      \     "specs/*.spec.js": {"alternate": "app/{}.js"},
      \   },
      \   "app/*.js": {
      \     "app/*.js": {"alternate": "specs/{}.spec.js"},
      \     "specs/*.spec.js": {"alternate": "app/{}.js"},
      \   }
      \ }

" *** Coding Plugs
" Snippet Engine
Plug 'SirVer/ultisnips'
set runtimepath+=~/.dotfiles " loads custom snippets at ~/.dotfiles/UltiSnips
let g:UltiSnipsExpandTrigger='<tab>'
let g:UltiSnipsJumpForwardTrigger='<tab>'

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

" Nice status bar
Plug 'vim-airline/vim-airline'
" Disable all extensions for vim-airline for better performance
let g:airline_extensions=[]

" Dark-powered Neovim autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup=1

" *** HTML/CSS/JSON Plugs
" HTML tag expander
Plug 'mattn/emmet-vim'

" Syntax highlighting and indentation for JSON
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0
let g:vim_json_warnings = 0

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

" *** Vim Plugs
" Plugin for vim development
Plug 'junegunn/vader.vim'

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

" Set folding
" Trigger folding with <Leader>z
" Open/Close all foldings via zR/zM
set foldnestmax=1
highlight Folded ctermbg=254 ctermfg=244

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

" JS with Flow shortcuts
" Require plugin flowtype/vim-flow
autocmd Filetype javascript nnoremap <C-]> :vsp<CR>:FlowJumpToDef<CR>zz

" Turn on autoformatting from NeoFormat plugin
autocmd BufWritePre *.js Neoformat

" Fix Yggdroot/indentLine after eslinting
autocmd BufWritePre * IndentLinesReset

" *****************************************
"     Personal Key mapping
" *****************************************

" Toggle folding
nmap <Space> za

" Insert a line break above
nmap K 0i<cr><esc>

" Auto-expand %% to the current file directory
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Navigation around windows
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <tab><tab> <c-w><c-w>

" Shift-Enter to escape in Insert Mode
inoremap <S-CR> <Esc>

" Map navigation in insert mode for deoplete auto-completion
imap <c-k> <Up>
imap <c-j> <Down>

" Remap for emmet-vim due to timeout issue in insert mode
imap <c-y> <esc><c-y>,i

" Move lines in normal, visual and insert modes
" ∆ is <A-j>
" ˚ is <A-k>
nnoremap ∆ :m .+1<CR>==
nnoremap ˚ :m .-2<CR>==
inoremap ∆ <Esc>:m .+1<CR>==gi
inoremap ˚ <Esc>:m .-2<CR>==gi
vnoremap ∆ :m '>+1<CR>gv=gv
vnoremap ˚ :m '<-2<CR>gv=gv

" *****************************************
"     Leader Mappings
" *****************************************

let mapleader = " "

" Run tests for javascript
" The script assumes you are running in a tmux session
" and there is a window named 6 to run the jest tests
" This is meant for my personal dual screen development setup
let clearRunningJestTest = 'tmux send-key -t 6 q && tmux send-key -t 6 BSpace '
let sendKeysToTmux= '!' . clearRunningJestTest . '&& tmux send-key -t 6 '
let endTmuxCommand = ' Enter'
let runAllTests = 'yarn test:watch'
let runCurrentFile = 'yarn test -- --watch %'
let runCurrentFileWithoutWatch = 'yarn test -- %'
map <Leader>a :execute sendKeysToTmux . '"' . runAllTests . '"' . endTmuxCommand<CR><bar>:echo 'Running all changed Jest tests'<CR>
map <Leader>t :execute sendKeysToTmux . '"' . runCurrentFile . '"' . endTmuxCommand<CR><bar>:echo 'Running current spec file'<CR>
map <Leader>s :execute sendKeysToTmux . '"' . runCurrentFileWithoutWatch . '"' . endTmuxCommand<CR><bar>:echo 'Running current spec file'<CR>

" Show the flow type of the variable under the cursor
map <Leader>T :FlowType<cr>

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

" Clear highlighted search
map <Leader>/ :nohlsearch<CR>

" Convert ruby hash from :abc => '123' to abc: '123'
map <Leader>h :%s/:\([^=,'"]*\) =>/\1:/g"']<CR>

" Auto-format the entire current file
map <Leader>= ggVG=

" Toggle paste and nopaste mode
nnoremap <Leader>p :set invpaste paste?<CR>

" Displays the registers
map <Leader>r :reg<CR>

" Trigger folding
map <Leader>z :setlocal foldmethod=syntax<CR>

" Yank the whole page
map <Leader>y mcggVGy`c
