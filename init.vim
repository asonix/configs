call plug#begin('~/.vim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'dsawardekar/ember.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'mustache/vim-mustache-handlebars'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/syntastic'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Plug 'floobits/floobits-neovim'

call plug#end()

colorscheme base16-twilight
let base16colorspace=256
set background=dark " dark | light "

filetype plugin indent on
set laststatus=2

set number "Show line numbers
set ruler  "Show line+column number of cursor

set autoindent
set smartindent

set expandtab
set shiftwidth=2
set tabstop=2

set hlsearch
set ignorecase
set smartcase

set backspace=indent,eol,start

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/dart-vim-plugin
endif
filetype plugin indent on

"set mouse=a

let g:airline_powerline_fonts = 1
let g:airline_section_b = '%{strftime("%c")}'
let g:airline_section_y = 'BN: %{bufnr("%")}'
let g:airline_theme='base16'
"let airline_theme='sol'
"let airline_theme='wombat'

let g:airline#extensions#tabline#enabled = 1

autocmd StdinReadPre * let s:std_in=1

let g:syntastic_cpp_check_header = 1
let g:syntastic_cpp_no_include_search = 1
let g:syntastic_cpp_no_default_include_dirs = 1
let g:syntastic_cpp_auto_refresh_includes = 1

let g:syntastic_cpp_compiler = 'g++'
let g:syntastic_cpp_compiler_options = ' -std=c++14'

let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_python_pyflakes_exec = '/usr/bin/pyflakes-python2'
let g:syntastic_python_python_exec = '/python2'

let g:syntastic_enable_elixir_checker = 1

" let g:syntastic_javascript_jslint_args = '--white --nomen --regexp --plusplus --bitwise --newcap --sloppy --vars --edition=latest'
let g:syntastic_javascript_checkers = ['jshint']

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

let g:rustfmt_autosave = 1

nmap <f8> :TagbarToggle<CR>
nmap <f9> :!pdflatex %<CR>
