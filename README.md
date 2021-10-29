# e-kaput.nvim

This simple plugin sets Neovim builin LSP diagnostics on a small popup window when you hover on the line with the errors, the popup goes away when the cursor moves off the line.

You can add borders, change background and use diferent signs, and diferent colors for each type of diagnostics.

![Screenshot](https://github.com/kaputi/e-kaput/raw/master/assets/screenshot1.png "Screenshot1")
![Screenshot](https://github.com/kaputi/e-kaput/raw/master/assets/screenshot2.png "Screenshot1")
![Screenshot](https://github.com/kaputi/e-kaput/raw/master/assets/screenshot3.png "Screenshot1")

## Commands
- EKaputToggle

## Configuration
### Minimal config
Load EKaput with defaults

lua:
```lua
require('e-kaput').setup({})
```
vimscript:
```viml
lua require('e-kaput').setup({})
```

### Advanced Config
Ekaput is enabled by default change this to disable it

lua:
```lua
require('e-kaput').setup({
 -- defaults
  enabled = true, -- true | false,  Enable EKaput.
  transparency = 25, -- 0 - 100 , transparecy percentage.
  borders = true, -- true | false, Borders.
  error_sign = '', -- Error sign.
  warning_sign = '', -- Warning sign.
  information_sign = '', -- Information sign.
  hint_sign = '' -- Hint sign.
})
```
vimscript: if set it will override anything passed to the setup in lua
```viml
" defaults
let e_kaput_enabled = 1
let e_kaput_transparency = 25
let e_kaput_borders = 1
let e_kaput_borders = 1
let e_kaput_error_sign = ''
let e_kaput_warning_sign = ''
let e_kaput_information_sign = ''
let e_kaput_hint_sign = ''
```

### Highlights

The highlights are linked to Lsp highlights, modify them to meet your needs.

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

vimscript
```viml
highlight link EKaputError LspDiagnosticsSignError
highlight link EKaputWarning LspDiagnosticsSignWarning
highlight link EKaputInformation LspDiagnosticsSignInformation
highlight link EKaputHint LspDiagnosticsSignHint
highlight link EKaputBorder LspDiagnosticsSignInformation
highlight link EKaputBackground NormalFloat
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
