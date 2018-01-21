call plug#begin('~/.config/nvim/plugged')

Plug 'airblade/vim-gitgutter'
Plug 'chriskempson/base16-vim'
Plug 'dart-lang/dart-vim-plugin'
Plug 'dsawardekar/ember.vim'
Plug 'elixir-lang/vim-elixir'
Plug 'ElmCast/elm-vim'
Plug 'ervandew/supertab'
Plug 'majutsushi/tagbar'
Plug 'mustache/vim-mustache-handlebars'
Plug 'racer-rust/vim-racer'
Plug 'rust-lang/rust.vim'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/syntastic'
Plug 'tpope/vim-fugitive'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Yggdroot/indentLine'

call plug#end()

colorscheme base16-mocha
let base16colorspace=256
set background=dark " dark | light "
hi Normal ctermbg=none

filetype plugin indent on
set laststatus=2

set number "Show line numbers
set ruler  "Show line+column number of cursor

set autoindent
set smartindent

set expandtab
set shiftwidth=4
set tabstop=4

set hlsearch
set ignorecase
set smartcase

set backspace=indent,eol,start

set hidden

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/dart-vim-plugin
endif
filetype plugin indent on

set mouse-=a

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
let g:syntastic_cpp_compiler_options = ' -std=c++14 -DRILEYS_COMPUTER'

let g:syntastic_python_checkers = ['pyflakes']
let g:syntastic_python_pyflakes_exec = '/usr/bin/pyflakes-python2'
let g:syntastic_python_python_exec = '/python2'

let g:syntastic_enable_elixir_checker = 1

let g:syntastic_javascript_checkers = ['jshint']

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:elm_syntastic_show_warnings = 1
let g:elm_jump_to_error = 1
let g:elm_make_output_file = "main.js"
let g:elm_make_show_warnings = 1
let g:elm_browser_command = ""
let g:elm_detailed_complete = 1
let g:elm_format_autosave = 1
let g:elm_format_fail_silently = 0
let g:elm_setup_keybindings = 1

set grepprg=grep\ -nH\ $*
let g:tex_flavor = "latex"

let g:rustfmt_autosave = 1

let g:racer_cmd = "/usr/bin/racer"
let g:racer_experimental_completer = 1

let g:syntastic_rust_rustc_exe = 'cargo check'
let g:syntastic_rust_rustc_fname = ''
let g:syntastic_rust_rustc_args = '--'
let g:syntastic_rust_checkers = ['rustc']

au FileType c nmap <f8> :TagbarToggle<CR>
au FileType cpp nmap <f8> :TagbarToggle<CR>
au FileType latex nmap <f9> :!pdflatex %<CR>

au FileType rust nmap gd <Plug>(rust-def)
au FileType rust nmap gs <Plug>(rust-def-split)
au FileType rust nmap gx <Plug>(rust-def-vertical)
au FileType rust nmap <leader>gd <Plug>(rust-doc)

" set clipboard+=unnamedplus
