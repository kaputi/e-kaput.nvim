local utils = {}

utils.getErrors = function(diagnostics)
	local severitySigns = {}
	severitySigns[1] = vim.g.ekaput_error_sign
	severitySigns[2] = vim.g.ekaput_warning_sign
	severitySigns[3] = vim.g.ekaput_information_sign
	severitySigns[4] = vim.g.ekaput_hint_sign

 local errors = {}
	for key, value in ipairs(diagnostics) do
    local source = ''
    if value['source'] ~= nil then
      source = '[' .. value['source'] .. ']'
    end

	local errorMessage = severitySigns[value['severity']] .. ' ' .. value['message'] .. source
		errors[key] = {message = errorMessage, severity = value['severity']}
	end
 return errors
end

-- bind next to local variable for efficiency
local next = next

utils.tableIsEmpty = function (table)
  if next(table) == nil then
    return true
  end
    return false
end

-- Errors highlight namespace
local ns_errors = vim.api.nvim_create_namespace('ekaput.floatErrors')

utils.populateBuffer = function (buf, errors)
	local severityHighlight = {}
	severityHighlight[1] = 'EKaputError'
	severityHighlight[2] = 'EKaputWarning'
	severityHighlight[3] = 'EKaputInformation'
	severityHighlight[4] = 'EKaputHint'


	for key, value in ipairs(errors) do
		vim.api.nvim_buf_set_lines(buf, key-1, key-1, false, {value['message']} )
		vim.api.nvim_buf_add_highlight(buf, ns_errors, severityHighlight[value['severity']] , key-1, 1, #value['message'])
	end
end

utils.longestErrorWidth = function (errors)
	local width = 0
	for key, value  in pairs(errors) do
		if #value[ 'message' ] > width then
			width = #value['message']
		end
	end
	return width
end

utils.checkWidth = function(width)
    local windowWidth = vim.api.nvim_list_uis()[1]['width']

    if width >= windowWidth - 6 then
      return windowWidth - 6
    end
     return width
end


utils.createFloatingWindow = function(buf,height,fittedWidth)

	    local floatWindowConfig = {
	      relative = 'cursor',
	      anchor = 'SW',
	      row = 0,
	      col = 1,
	      height = height,
	      width = fittedWidth,
	      focusable = false,
	      style = 'minimal'
	    }

	    vim.g.ekaput_win = vim.api.nvim_open_win(buf, false, floatWindowConfig )
	    vim.api.nvim_win_set_option(vim.g.BlWin, 'winblend', 25)

	    vim.g.ekaput_float_open = 1
end

return utils
