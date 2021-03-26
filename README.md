# e-kaput.nvim

This simple plugin sets Neovim builin LSP diagnostics on a small popup window when you hover on the line with the errors, the popup goes away when the cursor moves off the line.

You can add borders, change background and use diferent signs, and diferent colors for each type of diagnostics.

![Screenshot](https://github.com/kaputi/e-kaput/raw/master/assets/screenshot1.png "Screenshot1")
![Screenshot](https://github.com/kaputi/e-kaput/raw/master/assets/screenshot2.png "Screenshot1")
![Screenshot](https://github.com/kaputi/e-kaput/raw/master/assets/screenshot3.png "Screenshot1")

## Configuration

### Signs
You can modify the sign for each type of diagnostic

vimscript:
```viml
let g:ekaput_error_sign = ''
let g:ekaput_warning_sign = ''
let g:ekaput_information_sign = ''
let g:ekaput_hint_sign = ''
```
lua:
```lua
vim.g['ekaput_error_sign'] = ''
vim.g['ekaput_warning_sign'] = ''
vim.g['ekaput_information_sign'] = ''
vim.g['ekaput_hint_sign'] = ''
```

### Borders
You can turn on and of borders changing this

vimscript:
```viml
let g:ekaput_borders = 1
```
lua:
```lua
vim.g['ekaput_borders'] = 1
```

### Transparency
set the transparency of the floating window it can be a value between 0 for full transparency and 100 for no transparency.

vimscript:
```viml
let g:ekaput_transparency = 25
```
lua:
```lua
vim.g['ekaput_transparency'] = 25
```
### Highlights

The highlights are linked to Lsp highlights, modify them to meet your needs.

vimscript
```viml
highlight link EKaputError LspDiagnosticsSignError
highlight link EKaputWarning LspDiagnosticsSignWarning
highlight link EKaputInformation LspDiagnosticsSignInformation
highlight link EKaputHint LspDiagnosticsSignHint
highlight link EKaputBorder LspDiagnosticsSignInformation
highlight link EKaputBackground NormalFloat
```

lua
```lua
vim.cmd([[
  highlight link EKaputError LspDiagnosticsSignError
  highlight link EKaputWarning LspDiagnosticsSignWarning
  highlight link EKaputInformation LspDiagnosticsSignInformation
  highlight link EKaputHint LspDiagnosticsSignHint
  highlight link EKaputBorder LspDiagnosticsSignInformation
  highlight link EKaputBackground NormalFloat
]])
```

### Disable virtual text diagnostics
If you're like me, the virtual text diagnostics feel crowded, and are a distraction.
```lua
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   underline = true,
   virtual_text = false
 }
)
```
