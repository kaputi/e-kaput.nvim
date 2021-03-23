--[[
TODO:
	- line or word mode setting (if hover shows whole line error or just the range where the cursor is)
]]

local ekaput = {}

---@brief [[
--- float window with neovim builtin lsp errors on hover
---
--- <pre>
--- To find out more:
--- https://github.com/kaputi/e-kaput.nvim
---
--- </pre>
---@brief ]]

---@tag e-kaput.nvim

require ('e-kaput.options')

local utils = require('e-kaput.utils')

ekaput.openFloatingWindow = function()
  if vim.g.ekaput_float_open == 0 then
	  local lineDiagnostics = vim.lsp.diagnostic.get_line_diagnostics()
	  -- print(vim.inspect(lineDiagnostics))

	  local hasDiagnostics = not utils.tableIsEmpty(lineDiagnostics)

	  if hasDiagnostics then
	    local errors = utils.getErrors(lineDiagnostics)
	  --   -- print(vim.inspect(errors))

	    local buf  = vim.api.nvim_create_buf(false,true)
	    utils.populateBuffer(buf, errors)


	    local errorsWidth = utils.longestErrorWidth(errors)
      local fittedWidth = utils.checkWidth(errorsWidth)
	    utils.createFloatingWindow(buf,fittedWidth)

    end
  end

end

ekaput.closeFloatingWindow  = function ()
 if vim.g.ekaput_float_open ==  1 then
	 vim.api.nvim_win_close(vim.g.ekaput_win,true)
	 vim.g.ekaput_float_open = 0
 end
end

return ekaput
