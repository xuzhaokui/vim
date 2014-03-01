" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2008 Dec 17
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" This must be first, because it changes other options as a side effect.
set nocompatible
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" below is for golang
Bundle 'Blackrush/vim-gocode'
let g:go_fmt_autofmt = 0


Bundle 'tpope/vim-fugitive'
" original repos on github
Bundle 'lepture/vim-javascript'
" vim-scripts repos
"Bundle 'FuzzyFinder'
" non github repos
"Bundle 'git://git.wincent.com/command-t.git'
" git repos on your local machine (ie. when working on your own plugin)
"Bundle 'file:///Users/gmarik/path/to/plugin'
Bundle 'rizzatti/funcoo.vim'
Bundle 'rizzatti/dash.vim'

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Set to auto read when a file is changed from the outside 
set autoread
" set tabstop=4
set ai

" Set taglist
let Tlist_Ctags_Cmd = '/usr/bin/ctags'
let Tlist_Show_One_File=1
let Tlist_Exit_OnlyWindow=1
let Tlist_Auto_Open=0

" if has("vms")
"  set nobackup		" do not keep a backup file, use versions instead
" else
" set backup		" keep a backup file
" endif
"
set history=700		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching
set nobackup		" do not keep a backup file, use versions instead
set so=7
set wildmenu
set cmdheight=1
set hid
set whichwrap+=h,l
set smartcase
set magic
set showmatch

set mat=2 "How many tenths of a second to blink
" No sound on errors

" Always hide the statusline
set laststatus=1

" Format the statusline
set statusline=\ %{HasPaste()}%F%m%r%h\ %w\ \ CWD:\ %r%{CurDir()}%h\ \ \ Line:\ %l/%L:%c

function! CurDir()
       let curdir = substitute(getcwd(), '/Users/amir/', "~/", "g")
       return curdir
endfunction

function! HasPaste()
    if &paste
        return 'PASTE MODE  '
    else
        return ''
    endif
endfunction


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colors and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
syntax enable "Enable syntax hl

" Set font according to system
  set gfn=Monospace\ 10
  set shell=/bin/bash

  set nonu

if has("gui_running")
  set guioptions-=T
  set t_Co=256
  set background=light
  "colorscheme peaksea
  set nonu
else
  colorscheme elflord
  set background=dark
  syntax on
endif

set encoding=utf8
try
    lang en_US
catch
endtry

set ffs=unix,dos,mac "Default file types

" Don't use Ex mode, use Q for formatting
map Q gq
map n A{}<ESC>i
map m A()<ESC>i
map u A[]<ESC>i
map ; i""<ESC>i
map ' A()<ESC>i""<ESC>i
map g 0i//<ESC>
map f A<TAB>//<ESC>i**<ESC>i<SPACE><SPACE><ESC>hi

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

if has("mouse")
	set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Fast saving
nmap <leader>w :w!<cr>

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif


"Delete trailing white space, useful for Python ;)
func! DeleteTrailingWS()
	exe "normal mz"
	%s/\s\+$//ge
	exe "normal `z"
endfunc
autocmd BufWrite *.py :call DeleteTrailingWS()

set guitablabel=%t


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Spell checking
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Pressing ,ss will toggle and untoggle spell checking
map <leader>ss :setlocal spell!<cr>

"Shortcuts using <leader>
map <leader>sn ]s
map <leader>sp [s
map <leader>sa zg
map <leader>s? z=


""""""""""""""""""""""""""""""
" => Python section
""""""""""""""""""""""""""""""
"let python_highlight_all = 1
au FileType python syn keyword pythonDecorator True None False self

au BufNewFile,BufRead *.jinja set syntax=htmljinja
au BufNewFile,BufRead *.mako set ft=mako

au FileType python inoremap <buffer> $r return
au FileType python inoremap <buffer> $i import
au FileType python inoremap <buffer> $p print
au FileType python inoremap <buffer> $f #--- PH ----------------------------------------------<esc>FP2xi
au FileType python map <buffer> <leader>1 /class
au FileType python map <buffer> <leader>2 /def
au FileType python map <buffer> <leader>C ?class
au FileType python map <buffer> <leader>D ?def


""""""""""""""""""""""""""""""
" => Vim grep
""""""""""""""""""""""""""""""
let Grep_Skip_Dirs = 'RCS CVS SCCS .svn generated'
set grepprg=/bin/grep\ -nH

"""""""""""""""""""""""""""""""""""""""""""""""""""""
" => CSCOPE
"""""""""""""""""""""""""""""""""""""""""""""""""""""
cs add ./cscope.out

"""""""""""""""""""""""""""""""""""""""""
" => Grep.vim 
""""""""""""""""""""""""""""""""""""""""
nnoremap <silent> <F3> :Grep<CR>

"""""""""""""""""""""""""""""""""""""""""
" => pydiction
""""""""""""""""""""""""""""""""""""""""
filetype plugin on
let g:pydiction_location='~/.vim/after/ftplugin/pydiction/complete-dict'
"defalut g:pydiction_menu_height == 15
let g:pydiction_menu_height=20

"""""""""""""""""""""
" python_check_syntax
"""""""""""""""""""""
let g:pcs_hotkey='cpy'
let g:pcs_check_when_saving=1

"set paste

filetype indent on
set tags=tags;

"" For scsope
nmap <C-c><C-k> :cs find s <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-g> :cs find g <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-l> :cs find c <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-t> :cs find t <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-e> :cs find e <C-R>=expand("<cword>")<CR><CR>
nmap <C-c><C-f> :cs find f <C-R>=expand("<cfile>")<CR><CR>
nmap <C-c><C-i> :cs find i ^<C-R>=expand("<cfile>")<CR><CR>
nmap <C-c><C-d> :cs find d <C-R>=expand("<cword>")<CR><CR>


"set shiftwidth=4
"set tabstop=4
"set softtabstop=4
"set expandtab
"set autoindent

"" For golang syntax highlight
set rtp+=$GOROOT/misc/vim
filetype plugin indent on
syntax on

"install nerdtree
call pathogen#infect()
