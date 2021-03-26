if exists('g:loaded_ekaput')
  finish
endif
let g:loaded_e_kaput = 1
let g:ekaput_float_open=0

" Highlights
highlight default link EKaputError LspDiagnosticsSignError
highlight default link EKaputWarning LspDiagnosticsSignWarning
highlight default link EKaputInformation LspDiagnosticsSignInformation
highlight default link EKaputHint LspDiagnosticsSignHint
highlight default link EKaputBorder LspDiagnosticsSignInformation
highlight default link EkaputBackground NormalFloat

function! EKaputOpen()
  "TODO: Dont forget to remove this on
  " this reloads lua files when changed
  " lua for k in pairs(package.loaded) do if k:match("^e-kaput") then package.loaded[k] = nil end end
  lua require("e-kaput").openFloatingWindow()
endfun

function! EKaputClose()
  " TODO: Dont forget to remove this
  " this reloads lua files when changed
  " lua for k in pairs(package.loaded) do if k:match("^e-kaput") then package.loaded[k] = nil end end
  lua require("e-kaput").closeFloatingWindow()
endfun

augroup EkaputAutocommands
  autocmd!
  autocmd CursorHold * call EKaputOpen()
  autocmd CursorMoved * call EKaputClose()
augroup END
