# lspkind-nvim

This simple plugin sets Neovim builin LSP errors on a small popup window when you hover on the line with the errors, the popup goes away when the cursor moves off the line.

## Configuration

![Screenshot](https://github.com/kaputi/e-kaput/raw/master/assets/screenshot1.png "Screenshot1")

### highlights

The highlights are linked to Lsp highlights, modify them to meet your needs

```viml
highlight link EKaputError LspDiagnosticsSignError
highlight link EKaputWarning LspDiagnosticsSignWarning
highlight link EKaputInformation LspDiagnosticsSignInformation
highlight link EKaputHint LspDiagnosticsSignHint
```

