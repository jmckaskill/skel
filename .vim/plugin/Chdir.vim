" -*- vim -*-
" FILE: "c:/joze/.vim/autoload/Chdir.vim" {{{
" LAST MODIFICATION: "Wed, 19 Sep 2001 10:55:38 T-1 (Zellner)"
" (C) 2000 - 2001 by Johannes Zellner, <johannes@zellner.org>
" $Id: Chdir.vim,v 1.11 2001/09/19 07:57:21 joze Exp $ }}}

fun! Chdir()
    " substitute backslashes with forward slashes
    let dir = substitute(expand("%:p:h"), '\\', '/', 'g')
    " don't allow double slashes in file names
    let dir = substitute(dir, '//', '/', 'g')
    if exists("$TMPDIR")
	" substitute backslashes with forward slashes
	let tmp = substitute($TMPDIR, '\\', '/', 'g')
	if dir =~? tmp
	    " call confirm("not switching to tmpdir", '&ok')
	    return
	endif
    endif
    " CHANGE TO DIRECTORY OF CURRENT BUFFER
    if "" != bufname("%") && isdirectory(dir) " && dir != getcwd()
	let v:errmsg = ''
	silent! exe 'cd '.dir
	if v:errmsg != ''
	    return
	endif
	if expand(getcwd()) != expand("~")
	    " don't source the user's ~/.vimrc twice
	    if filereadable('.vimrc')
		exe 'source .vimrc'
	    elseif filereadable('_vimrc')
		exe 'source _vimrc'
	    endif
	endif
    endif
endfun

if exists('g:autoload') | finish | endif " used by the autoload generator

augroup CHDIR
    au!
    autocmd BufEnter * call Chdir()
augroup END

