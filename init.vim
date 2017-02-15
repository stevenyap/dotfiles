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
Plug 'neomake/neomake'
let g:neomake_javascript_enabled_makers = ['flow', 'eslint_d']
let g:neomake_jsx_enabled_makers = ['flow', 'eslint_d']
let g:neomake_error_sign = { 'text': 'X', 'texthl': 'ErrorMsg' }
let g:neomake_warning_sign = { 'text': 'W', 'texthl': 'WarningMsg' }
autocmd! BufWritePost,BufEnter * Neomake

" Toggles between relative and absolute line numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Fuzzy file matching
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files -co --exclude-standard']

" Ag silver searcher plugin
Plug 'rking/ag.vim'

" Move lines up and down
Plug 'matze/vim-move'
let g:move_key_modifier = 'C' " <C-k|j> Move current line/selections up|down

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
let g:AutoPairsShortcutBackInsert = '<C-b>'

" Displays a | for indentation
Plug 'Yggdroot/indentLine'

" Nice status bar
Plug 'vim-airline/vim-airline'
" Disable all extensions for vim-airline for better performance
let g:airline_extensions=['neomake']

" Dark-powered Neovim autocompletion
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
let g:deoplete#enable_at_startup=1

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

" Live preview of subsitution
set inccommand=split

" Faster escape in insert mode
autocmd InsertEnter * set timeoutlen=0 ttimeoutlen=0
autocmd InsertLeave * set timeoutlen=300 ttimeoutlen=300

" Set markdown syntax highlight
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
autocmd BufNewFile,BufReadPost *.md set wrap linebreak

" Set JSON filtype
autocmd BufRead,BufNewFile *.json set filetype=json

" JS with Flow shortcuts
" Require plugin flowtype/vim-flow
autocmd Filetype javascript nnoremap <C-]> :vsp<CR>:FlowJumpToDef<CR>zz

" Custom function to open alternate (specs) file for JS
" Type :A to jump between JS and specs
" Type :AV to open alternate file in an vertical split
" TODO: Make it configurable (eg. let g:javascript_alternate = ['**/*.js', 'specs/**/*.spec.js'])
function GetAlternateFile()
  let currentPath = expand('%')
  let path = split(currentPath, '/')

  if path[0] == "specs"
    let fileName = expand('%:t:r:r')
    let fileExtension = expand('%:e')
    let filePathWithoutSpecs = join(path[1:-2], '/')
    return filePathWithoutSpecs . '/' . fileName . '.' . fileExtension
  else
    let fileExtension = expand('%:e:e')
    let currentPathWithoutExtension = expand('%:r:r')
    return "specs/" . currentPathWithoutExtension . ".spec." . fileExtension
  endif
endfunction

function OpenAlternateFile()
  execute "edit " . GetAlternateFile()
endfunction

function OpenAlternateFileInVerticalSplit()
  execute "vsp " . GetAlternateFile()
endfunction

command A call OpenAlternateFile()
command AV call OpenAlternateFileInVerticalSplit()
" End: Custom function to open alternate (specs) file for JS

" *****************************************
"     Personal Key mapping
" *****************************************

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
let runAllTests = 'npm run watch:test'
let runCurrentFile = 'jest --watch %'
map <Leader>a :execute sendKeysToTmux . '"' . runAllTests . '"' . endTmuxCommand<CR><bar>:echo 'Running all changed Jest tests'<CR>
map <Leader>t :execute sendKeysToTmux . '"' . runCurrentFile . '"' . endTmuxCommand<CR><bar>:echo 'Running current spec file'<CR>

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
