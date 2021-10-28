--[[
TODO:
	- line or word mode setting (if hover shows whole line error or just the range where the cursor is)
]] local ekaput = {}

---@brief [[
--- float window with neovim builtin lsp errors on hover
---
--- To find out more:
--- https://github.com/kaputi/e-kaput.nvim
---
---@brief ]]

---@tag e-kaput.nvim

require('e-kaput.options')

local utils = require('e-kaput.utils')

ekaput.openFloatingWindow = function()
  if vim.g.ekaput_enabled ~= 1 then return end
  if vim.g.ekaput_float_open == 0 then
    local lineDiagnostics = vim.lsp.diagnostic.get_line_diagnostics()

    local hasDiagnostics = not utils.tableIsEmpty(lineDiagnostics)

    if hasDiagnostics then
      local errors = utils.formatErrors(lineDiagnostics)

      local errorBuffer = utils.errorBuffer(errors)

      local errorWindow = utils.createErrorWindow(errorBuffer)

      vim.g.ekaput_error_win = errorWindow
      vim.g.ekaput_error_buf = errorBuffer

      -- if vim.g.ekaput_borders == 1 then
      --   local borderBuffer = utils.borderBuffer(errorBuffer)
      --   local borderWindow = utils.createBorderWindow(borderBuffer)
      --   vim.g.ekaput_border_win = borderWindow
      --   vim.g.ekaput_border_buf = borderBuffer
      -- end

      vim.g.ekaput_float_open = 1
    end
  end

end

ekaput.closeFloatingWindow = function()
  if vim.g.ekaput_enabled ~= 1 then return end
  if vim.g.ekaput_float_open == 1 then
    vim.api.nvim_win_close(vim.g.ekaput_error_win, true)
    vim.api.nvim_buf_delete(vim.g.ekaput_error_buf, {force = true})
    if vim.g.ekaput_borders == 1 then
      vim.api.nvim_win_close(vim.g.ekaput_border_win, true)
      vim.api.nvim_buf_delete(vim.g.ekaput_border_buf, {force = true})
    end
    vim.g.ekaput_float_open = 0
  end
end

ekaput.toggle = function()
  ekaput.closeFloatingWindow()
  if vim.g.ekaput_enabled == 0 then
    vim.g.ekaput_enabled = 1
  elseif vim.g.ekaput_enabled == 1 then
    vim.g.ekaput_enabled = 0
  end
end

return ekaput
