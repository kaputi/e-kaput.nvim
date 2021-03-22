# lspkind-nvim

This simple plugin sets Neovim builin LSP diagnostics on a small popup window when you hover on the line with the errors, the popup goes away when the cursor moves off the line.

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
### Highlights

The highlights are linked to Lsp highlights, modify them to meet your needs.

```viml
highlight link EKaputError LspDiagnosticsSignError
highlight link EKaputWarning LspDiagnosticsSignWarning
highlight link EKaputInformation LspDiagnosticsSignInformation
highlight link EKaputHint LspDiagnosticsSignHint
```

### Disable virtual text diagnostics
If you're like me, the virtual text diagnostics feel crowded, and are a distraction.
```lua
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
 vim.lsp.diagnostic.on_publish_diagnostics, {
   -- Enable underline, use default values
   underline = true,
   -- Enable virtual text only on Warning or above, override spacing to 2
   -- virtual_text = {
   --   spacing = 2,
   --   severity_limit = "Warning",
   -- },
   virtual_text = false
 }
)
```
