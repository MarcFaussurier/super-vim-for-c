" **************************************************************************** "
"                                                                              "
"                                                         :::      ::::::::    "
"    42header.vim                                               /              "
"                                                     +:+ +:+         +:+      "
"    By: pbondoer <pbondoer@student.42.fr>          +#+  +:+       +#+         "
"                                                 +#+#+#+#+#+   +#+            "
"    Created: 2015/12/06 19:39:01 by pbondoer          #+#    #+#              "
"    Created: 2019/08/24 14:58:27 by marcfsr      #+#   ##    ##    #+#        "
"                                                                              "
" **************************************************************************** "

" Common configuration between vim and neovim
filetype plugin indent on
set tabstop=4
set shiftwidth=4
set expandtab
set mouse=a
set number
set showcmd
highlight ColorColumn ctermbg=gray
set colorcolumn=80

" Personal file header
let s:asciiart = [
			\"           LE - /         ",
			\"               /          ",
			\"     .::    .:/ .      .::",
			\"  +:+:+   +:    +:  +:+:+ ",
			\"   +:+   +:    +:    +:+  ",
			\"  #+#   #+    #+    #+#   ",
			\" #+#   ##    ##    #+#    ",
			\"###    #+./ #+    ###.fr  ",
			\"         /   UNIV -       ",
			\"| |  _  / ___ _ _   / |   ",
 			\"| |_| || / _ \\ ' \\  | |   ",
 			\"|____\\_, \\___/_||_| |_|   ",
      		\"     /__/            .fr  "
		\]

let s:start		= '/*'
let s:end		= '*/'
let s:fill		= '*'
let s:length	= 80
let s:margin	= 5

let s:types		= {
			\'\.c$\|\.h$\|\.cc$\|\.hh$\|\.cpp$\|\.hpp$\|\.php\|\.glsl':
			\['/*', '*/', '*'],
			\'\.htm$\|\.html$\|\.xml$':
			\['<!--', '-->', '*'],
			\'\.js$':
			\['//', '//', '*'],
			\'\.tex$':
			\['%', '%', '*'],
			\'\.ml$\|\.mli$\|\.mll$\|\.mly$':
			\['(*', '*)', '*'],
			\'\.vim$\|\vimrc$':
			\['"', '"', '*'],
			\'\.el$\|\emacs$':
			\[';', ';', '*'],
			\'\.f90$\|\.f95$\|\.f03$\|\.f$\|\.for$':
			\['!', '!', '/']
			\}

function! s:filetype()
	let l:f = s:filename()

	let s:start	= '#'
	let s:end	= '#'
	let s:fill	= '*'

	for type in keys(s:types)
		if l:f =~ type
			let s:start	= s:types[type][0]
			let s:end	= s:types[type][1]
			let s:fill	= s:types[type][2]
		endif
	endfor

endfunction

function! s:ascii(n)
	return s:asciiart[a:n - 2]
endfunction

function! s:textline(left, right)
	let l:left = strpart(a:left, 0, s:length - s:margin * 3 - strlen(a:right) + 1)

	return s:start . repeat(' ', s:margin - strlen(s:start)) . l:left . repeat(' ', s:length - s:margin * 2 - strlen(l:left) - strlen(a:right)) . a:right . repeat(' ', s:margin - strlen(s:end)) . s:end
endfunction

function! s:line(n)
	if a:n == 1 || a:n == 15 " top and bottom line
		return s:start . ' ' . repeat(s:fill, s:length - strlen(s:start) - strlen(s:end) - 2) . ' ' . s:end
	elseif a:n == 2 || a:n == 11 || a:n == 14 || a:n == 9 || a:n == 10
		return s:textline('', s:ascii(a:n))
	elseif a:n == 3 || a:n == 5 || a:n == 8 " empty with ascii
		return s:textline('', s:ascii(a:n))
	elseif a:n == 4 " filename
		return s:textline(s:filename(), s:ascii(a:n))
	elseif a:n == 6 " author
		return s:textline("Authors: " . s:user(), s:ascii(a:n))
	elseif a:n == 7 " author
		return s:textline("<" . s:mail() . ">", s:ascii(a:n))
	elseif a:n == 12 " created
		return s:textline("Created: " . s:date() . " by " . s:user(), s:ascii(a:n))
	elseif a:n == 13 " updated
		return s:textline("Updated: " . s:date() . " by " . s:user(), s:ascii(a:n))
	endif
endfunction

function! s:user()
	let l:user = $USER
	if exists('g:hdr42user')
		let l:user = g:hdr42user
	endif
	if strlen(l:user) == 0 || l:user == "marcfsr"
		let l:user = "mfaussur"
	endif
	return l:user
endfunction

function! s:mail()
	let l:mail = $MAIL
	if exists('g:hdr42mail')
		let l:mail = g:hdr42mail
	endif
	if strlen(l:mail) == 0
		let l:mail = "marc.faussurier@etu.univ-lyon1.fr"
	endif
	return l:mail
endfunction

function! s:filename()
	let l:filename = expand("%:t")
	if strlen(l:filename) == 0
		let l:filename = "< new >"
	endif
	return l:filename
endfunction

function! s:date()
	return strftime("%Y/%m/%d %H:%M:%S")
endfunction

function! s:insert()
	let l:line = 15

	" empty line after header
	call append(0, "")

	" loop over lines
	while l:line > 0
		call append(0, s:line(l:line))
		let l:line = l:line - 1
	endwhile
endfunction

function! s:update()
	call s:filetype()
	if getline(13) =~ s:start . repeat(' ', s:margin - strlen(s:start)) . "Updated: "
		if &mod
			call setline(13, s:line(13))
		endif
		call setline(4, s:line(4))
		return 0
	endif
	return 1
endfunction

function! s:stdheader()
	if s:update()
		call s:insert()
	endif
endfunction

" Bind command and shortcut
command! Stdheader call s:stdheader ()
nmap <f1> <esc>:Stdheader<CR>
autocmd BufWritePre * call s:update ()
