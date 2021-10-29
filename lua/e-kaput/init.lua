--[[
TODO:
	- line or word mode setting (if hover shows whole line error or just the range where the cursor is)
  - Better border options
  - docs
  - refresh on lspdiagnostics(when formatter changes something it still shows until cursor moved)
]] local ekaput = {}

---@brief [[
--- float window with neovim builtin lsp errors on hover
---
--- To find out more:
--- https://github.com/kaputi/e-kaput.nvim
---
---@brief ]]

---@tag e-kaput.nvim

local utils = require('e-kaput.utils')

local config = {}
local defaults = require('e-kaput.config')

local float_open = 0
local window, buffer

-- if any vim variable is set change vehabiour without restart
local vim_vs_lua = function()
  if vim.g.e_kaput_enabled ~= nil then
    if vim.g.e_kaput_enabled == 1 then
      config.enabled = true
    else
      config.enabled = false
    end
  end

  if vim.g.e_kaput_error_sign ~= nil then
    config.error_sign = vim.g.e_kaput_error_sign
  end

  if vim.g.e_kaput_warning_sign ~= nil then
    config.warning_sign = vim.g.e_kaput_warning_sign
  end

  if vim.g.e_kaput_information_sign ~= nil then
    config.information_sign = vim.g.e_kaput_information_sign
  end

  if vim.g.e_kaput_hint_sign ~= nil then
    config.hint_sign = vim.g.e_kaput_hint_sign
  end

  if vim.g.e_kaput_borders ~= nil then
    if vim.g.e_kaput_borders == 1 then
      config.borders = true
    else
      config.borders = false

    end
  end

  if vim.g.e_kaput_transparency ~= nil then
    config.transparency = vim.g.e_kaput_transparency
  end
end

ekaput.setup = function(values)
  utils.highlights()
  utils.commands()

  setmetatable(config, {__index = vim.tbl_extend('force', defaults, values)})

  -- Check if settings are set in vimscript
  vim_vs_lua()
end

ekaput.openFloatingWindow = function()
  vim_vs_lua()
  if config.enabled == nil or config.enabled == false then return end

  if float_open == 0 then
    local lineDiagnostics = vim.lsp.diagnostic.get_line_diagnostics()

    local hasDiagnostics = not utils.tableIsEmpty(lineDiagnostics)

    if hasDiagnostics then
      local errors = utils.formatErrors(lineDiagnostics, config)

      local errorBuffer = utils.errorBuffer(errors)

      local errorWindow = utils.createErrorWindow(errorBuffer, config)

      window = errorWindow
      buffer = errorBuffer

      float_open = 1
    end
  end

end

ekaput.closeFloatingWindow = function()
  -- vim_vs_lua()
  -- if config.enabled == nil or config.enabled == false then return end
  if float_open == 1 then
    vim.api.nvim_win_close(window, true)
    vim.api.nvim_buf_delete(buffer, {force = true})
    float_open = 0
  end
end

ekaput.toggle = function()
  ekaput.closeFloatingWindow()
  if vim.g.e_kaput_enabled ~= nil then
    if vim.g.ekaput_enabled == false then
      vim.g.ekaput_enabled = true
    elseif vim.g.ekaput_enabled == true then
      vim.g.ekaput_enabled = false
    else
      vim.g.e_kaput_enabled = false
    end
  else
    if config.enabled ~= nil then
      if config.enabled == true then
        config.enabled = false
      elseif config.enabled == false then
        config.enabled = true
      else
        config.enabled = false
      end
    else
      config.enabled = false
    end
  end
end

return ekaput
