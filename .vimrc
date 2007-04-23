" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2002 Sep 19
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

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=50		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" This is an alternative that also works in block mode, but the deleted
" text is lost and it only works for putting the current register.
"vnoremap p "_dp

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

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")
"Personal modifications
set mouse=a
set tabstop=4
set shiftwidth=4
set softtabstop=4
set laststatus=2
"set smarttab
map ; :
set nu
set scs
set ai
set sm
set mousefocus
set mousehide
map n nzz
map <F5> :setlocal spell! spelllang=en_gb<CR>
imap <F5> <C-o>:setlocal spell! spelllang=en_gb<CR>
set ignorecase smartcase
"Fix up bloody annoying wrapping behaviour in relation to moving up/down 
"note: n, v, i prefixes of noremap are for the mode of operation
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk
nnoremap <Down> gj
nnoremap <Up> gk
vnoremap <Down> gj
vnoremap <Up> gk
inoremap <Down> <C-o>gj
inoremap <Up> <C-o>gk
"au InsertEnter * se cul
"au InsertEnter * hi CursorLine term=none cterm=none ctermbg=8
"au InsertLeave * se nocul
"clean up macros such that to play back the @q macro just use Q
noremap Q @q
"code folding ...
set foldmethod=syntax
set foldcolumn=1
set foldlevel=255
 "make things a bit easier
map zx zo
"commands to use folding
"zc: close fold
"zo: open fold
"zR: open all folds
"zM: close all folds
"see: http://vimdoc.sourceforge.net/htmldoc/fold.html
set grepprg=grep\ -nH\ $*
"au FileType tex :TTarget pdf
"let g:Tex_CompileRule_pdf = 'pdflatex --interaction=nonstopmode $*'
"let g:Tex_FormatDependency_pdf = ''
"for saving stuff
noremap <F1> :wq<CR>
noremap <F2> :w<CR>
noremap <F3> :q!<CR>
inoremap <F1> <C-o>:wq<CR>
inoremap <F2> <C-o>:w<CR>
inoremap <F3> <C-o>:q!<CR>
"au FileType tex noremap <F6> :w<CR>:!bash -c 'pdflatex `cat main`'<CR><CR>
"au FileType tex inoremap <F6> <C-o>:w<CR><C-o>:!bash -c 'pdflatex `cat main`'<CR><CR>
noremap <F6> :w<CR>:!make<CR>
inoremap <F6> <C-o>:w<CR><C-o>:!make<CR>
"fixing up horrible indentation
noremap <F4> gg=G
inoremap <F4> <C-o>gg=G
"Summary of F keys
"F1 - save and exit
"F2 - save
"F3 - exit and don't save
"F4 - fix up horrible indentation
"F5 - toggle spellcheck 
