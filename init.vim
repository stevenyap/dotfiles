" Start declaring all Plugins
autocmd!
let g:node_host_prog = expand('~/.nvm/versions/node/v16.13.2/bin/neovim-node-host')
call plug#begin('~/.config/nvim/plugged')

" Use solarized color scheme
Plug 'iCyMind/NeoSolarized'

" Read the file automatically when returning back to Vim
Plug 'djoshea/vim-autoread'

" Toggles between relative and absolute line numbers automatically
Plug 'jeffkreeftmeijer/vim-numbertoggle'

" Fuzzy file matching
Plug 'ctrlpvim/ctrlp.vim'
let g:ctrlp_use_caching = 0
let g:ctrlp_user_command = 'ag --path-to-ignore ~/Workspace/dotfiles/.ignore --literal --files-with-matches --nocolor --hidden -g "" %s'
nnoremap <c-b> :CtrlPBuffer<CR>

" Ag silver searcher plugin
Plug 'numkil/ag.nvim'
let g:ag_prg = 'ag --path-to-ignore ~/Workspace/dotfiles/.ignore --vimgrep --silent'

" Git plugin
Plug 'tpope/vim-fugitive'

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
let g:indentLine_color_term = 239 " Solarized base2 color 

" Overwrites Yggdroot/indentLine conceal level properly for Json
Plug 'elzr/vim-json'
let g:vim_json_syntax_conceal = 0

" Nice status bar
Plug 'vim-airline/vim-airline'
" Disable all extensions for vim-airline for better performance
let g:airline_extensions=['coc']
let g:airline#extensions#coc#enabled = 1

" Displays directory file system on the side
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeAutoDeleteBuffer = 1
let NERDTreeIgnore=['node_modules', '.git$', '\.swp$', 'rethinkdb_data', '\.DS_Store$', '\.firebase']

" Track IDE time in wakatime.com
Plug 'wakatime/vim-wakatime'

" Always need a nyan cat to unwind
Plug 'koron/nyancat-vim'

" Autocomplete with Language Server Support
" https://github.com/neoclide/coc.nvim/wiki/Debug-language-server#using-output-channel
" let $NVIM_COC_LOG_LEVEL = 'debug'
" :CocCommand workspace.showOutput
" Requirements:
" soft link `ln -s <PATH>/dotfiles/coc-settings.json ~/.config/nvim/coc-settings.json`
" npm install -g @elm-tooling/elm-language-server elm elm-test elm-format 
" rustup component add rls rust-analysis rust-src
" cabal install hlint ormolu
" We need the master build of hls because 1.7.0.0 uses an outdated hlint
" ghcup compile hls --git-ref 21e8ac565b -o 1.7.0.0-nightly --ghc 9.0.2
Plug 'neoclide/coc.nvim', {'branch': 'release'}
let g:coc_global_extensions = [ 'coc-tsserver', 'coc-eslint', 'coc-json', 'coc-prettier', 'coc-css', 'coc-html', 'coc-fsharp', 'coc-yaml', 'coc-groovy', 'coc-rust-analyzer', 'coc-sql' ]
let g:coc_snippet_next = '<c-t>'
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gt <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap          gn <Plug>(coc-rename)
nmap <silent> gh :call ShowDocumentation()<CR>
nmap          go <Plug>(coc-float-jump)
nmap          gl <Plug>(coc-codelens-action)
nmap          gf <Plug>(coc-fix-current)
nmap          ga <Plug>(coc-codeaction-selected)<CR>
nmap          gA <Plug>(coc-codeaction)
nmap <silent> gk <Plug>(coc-diagnostic-prev)
nmap <silent> gj <Plug>(coc-diagnostic-next)
function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Map navigation & Enter in insert mode for auto-completion
inoremap <silent><expr> <C-j> coc#pum#visible() ? coc#pum#next(1) : "\<C-j>"
inoremap         <expr> <C-k> coc#pum#visible() ? coc#pum#prev(1) : "\<C-k>"
inoremap         <expr> <CR>  coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" Syntax highlighting for elm
Plug 'andys8/vim-elm-syntax'

" Syntax highlighting for Javascript
Plug 'pangloss/vim-javascript'

" Syntax highlighting for React Typescript
Plug 'HerringtonDarkholme/yats.vim'
Plug 'maxmellon/vim-jsx-pretty'

" Syntax highlighting for JSON-C files
" Manually set individual json file to allow commenting at [JSONCFILES]
Plug 'neoclide/jsonc.vim'

" F# Syntax highlight
Plug 'kongo2002/fsharp-vim'

" firestore.rules Syntax highlight
Plug 'delphinus/vim-firestore'

" Markdown
Plug 'gabrielelana/vim-markdown'

" GraphQL
Plug 'jparise/vim-graphql'

" Initialize plugin system
call plug#end()

" *****************************************
"     NeoVim Settings
" *****************************************

let g:loaded_perl_provider = 0

" Color scheme
set termguicolors
set background=dark
colorscheme NeoSolarized
highlight CocFloating guibg=#1c1c1c 
highlight CocHintSign guifg=#666666 

set updatetime=300
set signcolumn=yes
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

" [JSONCFILES] Manually set individual json file to allow commenting
autocmd BufRead,BufNewFile tsconfig.json set filetype=jsonc

" Hides ^M when opening Windows files
autocmd BufReadPre,BufNewFile *.fsproj set fileformat=unix
autocmd BufReadPre,BufNewFile *.fs set fileformat=unix

" Saves undo into a file and use it across all vim sessions
set undodir=~/.nvim/undo
set undofile

autocmd BufNewFile,BufReadPost *.mjml set filetype=html
autocmd BufNewFile,BufReadPost Jenkinsfile set filetype=groovy

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

" Toggle relative line number
nnoremap <silent> <C-n> :set relativenumber!<cr>


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
