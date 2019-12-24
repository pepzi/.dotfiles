function! MyFoldText()
    let nblines = v:foldend - v:foldstart + 1
    let w = winwidth(0) - &foldcolumn - (&number ? 8 : 0)
    let line = getline(v:foldstart)
    let comment = substitute(line, '/\*\|\*/\|{{{\d\=', '', 'g')
    let expansionString = repeat(".", w - strwidth(nblines.comment.'"'))
    let txt = '"' . comment . expansionString . nblines
    return txt
endfunction

