autocmd FileType orelog nnoremap <buffer> <silent> <Enter>   :call <SID>OrelogOnEnter()<Enter>
autocmd FileType orelog nnoremap <buffer> <silent> <C-Enter> :call <SID>OrelogOnCtrlEnter()<Enter>
autocmd FileType orelog nnoremap <buffer> <silent> <C-_>     :call <SID>OrelogOnCtrlMinus()<Enter>

if !exists('g:orelog_dir')
    let g:orelog_dir = '~/Scratch'
endif

if !exists('g:orelog_ext')
    let g:orelog_ext = ''
else
    if strlen(g:orelog_ext) && g:orelog_ext !~ '^\.'
        let g:orelog_ext = '.' . g:orelog_ext
    endif
endif

function! s:OrelogNew()
    execute 'edit ' . g:orelog_dir . '/' . strftime('%Y-%m-%d') . g:orelog_ext
endfunction

function! s:OrelogGrep(word)
    execute 'vimgrep /' . a:word . '/j ' . g:orelog_dir . '/*'
    call setqflist(reverse(getqflist()))
endfunction

function! s:OrelogTitles()
    silent! call s:OrelogGrep('\(\%^\|\_^--\n\)\zs.*')
endfunction

function! s:OrelogTag(tag)
    silent! call s:OrelogGrep('\(\%^\|\_^--\n\)\zs.* - .*\c' . a:tag)
endfunction

function! s:OrelogOnEnter()
    let token_type = synIDattr(synID(line('.'), col('.'), 1), 'name')

    if token_type =~ 'Tags$'
        call <SID>OrelogTag(expand('<cword>'))
    elseif token_type =~ 'URL$' && exists('*AL_open_url')
        let reg_save = @"
        let cursor_save = getpos('.')

        normal yiW
        call AL_open_url(@", '')

        let @" = reg_save
        call setpos('.', cursor_save)
    endif
endfunction

function! s:OrelogOnCtrlEnter()
    let token_type = synIDattr(synID(line('.'), col('.'), 1), 'name')

    if token_type =~ 'Sync' || token_type =~ '^hatena'
        try
            SyncPush
        endtry
    endif
endfunction

function! s:OrelogOnCtrlMinus()
    let token_type = synIDattr(synID(line('.'), col('.'), 1), 'name')

    if token_type =~ 'Sync' || token_type =~ '^hatena'
        try
            SyncPull
        endtry
    endif
endfunction

function! OrelogCalDayAction(day, month, year, week, dir)
    wincmd p
    execute 'edit ' . g:orelog_dir . '/' . printf('%d-%02d-%02d', a:year, a:month, a:day) . g:orelog_ext
    wincmd p
endfunction

let g:calendar_action = 'OrelogCalDayAction'

command! -nargs=0 OrelogNew         call <SID>OrelogNew()
command! -nargs=1 OrelogGrep        call <SID>OrelogGrep(<q-args>)
command! -nargs=0 OrelogTitles      call <SID>OrelogTitles()
command! -nargs=1 OrelogTag         call <SID>OrelogTag(<q-args>)
