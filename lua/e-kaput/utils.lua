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

local break_lines = function(inputstr, sep)
  if sep == nil then
    sep = "%s"
  end
  local t={}
  for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
    table.insert(t, str)
  end
  return t
end

-- Errors highlight namespace
local ns_errors = vim.api.nvim_create_namespace('ekaput.floatErrors')

utils.populateBuffer = function (buf, errors)
	local severityHighlight = {}
	severityHighlight[1] = 'EKaputError'
	severityHighlight[2] = 'EKaputWarning'
	severityHighlight[3] = 'EKaputInformation'
	severityHighlight[4] = 'EKaputHint'

	for _, value in ipairs(errors) do

    local message =  break_lines(value['message'],'\n')
    local pre_lines = vim.api.nvim_buf_line_count(buf)
    vim.api.nvim_buf_set_lines(buf, pre_lines-1, #message, false, message )
    local post_lines = vim.api.nvim_buf_line_count(buf)

    for i = 0, post_lines , 1 do
      vim.api.nvim_buf_add_highlight(buf, ns_errors, severityHighlight[value['severity']] , i, 0, -1)
    end

	end
end

utils.longestErrorWidth = function (errors)
	local width = 0
	for _, value  in pairs(errors) do
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


utils.createFloatingWindow = function(buf,fittedWidth)

	    local floatWindowConfig = {
	      relative = 'cursor',
	      anchor = 'SW',
	      row = 0,
	      col = 1,
	      height = vim.api.nvim_buf_line_count(buf),
	      width = fittedWidth,
	      focusable = false,
	      style = 'minimal'
	    }

	    vim.g.ekaput_win = vim.api.nvim_open_win(buf, false, floatWindowConfig )
	    vim.api.nvim_win_set_option(vim.g.BlWin, 'winblend', vim.g.ekaput_transparency)

	    vim.g.ekaput_float_open = 1
end

return utils
