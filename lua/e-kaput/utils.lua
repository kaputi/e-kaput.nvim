local api = vim.api

local utils = {}

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- local functions

local break_lines = function(inputstr, sep)
  if sep == nil then sep = "%s" end
  local t = {}
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    for cleanstr in string.gmatch(str, '%S[%S%s]+') do
      table.insert(t, cleanstr)
    end
  end
  return t
end

local bufferWidth = function(buf)
  local lines = api.nvim_buf_get_lines(buf, 0, api.nvim_buf_line_count(buf),
      true)

  local width = 0

  for _, value in pairs(lines) do if #value > width then width = #value end end

  return width
end
-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Check if table is empty

-- bind next to local variable for efficiency
local next = next

utils.tableIsEmpty = function(table)
  if next(table) == nil then return true end
  return false
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Get formated errors

utils.formatErrors = function(diagnostics)
  local severitySigns = {}
  severitySigns[1] = vim.g.ekaput_error_sign
  severitySigns[2] = vim.g.ekaput_warning_sign
  severitySigns[3] = vim.g.ekaput_information_sign
  severitySigns[4] = vim.g.ekaput_hint_sign

  local errors = {}
  for key, value in ipairs(diagnostics) do
    local source = ''
    if value['source'] ~= nil then source = '[' .. value['source'] .. ']' end

    local error = break_lines(value['message'], '\n')
    if type(error) == "table" then
      for multiKey, multiValue in ipairs(error) do
        local errorMessage = ' '
        if multiKey == 1 then
          errorMessage = severitySigns[value['severity']] .. ' '
        end
        errorMessage = errorMessage .. multiValue
        if multiKey == #error then errorMessage = errorMessage .. source end
        table.insert(errors,
            {message = errorMessage, severity = value['severity']})
      end

    elseif type(error) == "string" then
      local errorMessage = severitySigns[value['severity']] .. ' ' .. error ..
                               source
      errors[key] = {message = errorMessage, severity = value['severity']}
    end

  end
  return errors
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Create errors buffer

-- Errors highlight namespace
local ns_errors = api.nvim_create_namespace('ekaput.floatErrors')

utils.errorBuffer = function(errors)
  local buf = api.nvim_create_buf(false, true)

  local severityHighlight = {}
  severityHighlight[1] = 'EKaputError'
  severityHighlight[2] = 'EKaputWarning'
  severityHighlight[3] = 'EKaputInformation'
  severityHighlight[4] = 'EKaputHint'

  for key, value in ipairs(errors) do

    local message = value['message']

    local line = key - 1
    api.nvim_buf_set_lines(buf, line, -1, false, {message})

    api.nvim_buf_add_highlight(buf, ns_errors,
        severityHighlight[value['severity']], line, 1, #message)

  end
  return buf
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- Create error window

utils.createErrorWindow = function(buf)

  local bufWidth = bufferWidth(buf)

  local row = 0
  local col = 1

  if vim.g.ekaput_borders then
    row = -1
    col = 2
  end

  local config = {
    relative = 'cursor',
    anchor = 'SW',
    row = row,
    col = col,
    height = api.nvim_buf_line_count(buf),
    width = bufWidth,
    focusable = false,
    style = 'minimal',
    border = {
      {'╭', 'EKaputBorder'}, {'─', 'EKaputBorder'}, {'╮', 'EKaputBorder'},
      {'│', 'EKaputBorder'}, {'╯', 'EKaputBorder'}, {'─' , 'EKputBorder'},
      {'╰', 'EKaputBorder'}, {'│', 'EKaputBorder'}

    }
  }

  local window = api.nvim_open_win(buf, false, config)
  vim.api.nvim_win_set_option(window, 'winblend', vim.g.ekaput_transparency)
  vim.api.nvim_win_set_option(window, 'winhl', 'NormalFloat:EKaputBackground')

  return window
end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- create border buffer

-- utils.borderBuffer = function(errorBuffer)
--   local buf = api.nvim_create_buf(false, true)

--   local width = bufferWidth(errorBuffer) + 2
--   local height = api.nvim_buf_line_count(errorBuffer) + 2

--   local topborder = "╭"
--   local bottomborder = "╰"
--   local middleborder = "│"

--   for _ = 1, width - 2, 1 do
--     topborder = topborder .. "─"
--     bottomborder = bottomborder .. "─"
--     middleborder = middleborder .. " "
--   end
--   topborder = topborder .. "╮"
--   bottomborder = bottomborder .. "╯"
--   middleborder = middleborder .. "│"

--   api.nvim_buf_set_lines(buf, 0, -1, false, {topborder})
--   api.nvim_buf_add_highlight(buf, ns_errors, 'EKaputBorder', 0, 1, #topborder)

--   for i = 1, height - 2, 1 do
--     api.nvim_buf_set_lines(buf, i, -1, false, {middleborder})
--     api.nvim_buf_add_highlight(buf, ns_errors, 'EKaputBorder', i, 1,
--         #middleborder)
--   end
--   local line_count = api.nvim_buf_line_count(buf)

--   api.nvim_buf_set_lines(buf, line_count, -1, false, {bottomborder})
--   api.nvim_buf_add_highlight(buf, ns_errors, 'EKaputBorder', line_count, 1,
--       #bottomborder)

--   return buf
-- end

-- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- --
-- -- create border window
-- utils.createBorderWindow = function(buf)

--   -- the characters used for the middle borders count as 2 each
--   local lines = api.nvim_buf_get_lines(buf, 1, 2, true)
--   local width = #lines[1] - 4

--   local config = {
--     relative = 'cursor',
--     anchor = 'SW',
--     row = 0,
--     col = 1,
--     height = vim.api.nvim_buf_line_count(buf),
--     width = width,
--     focusable = false,
--     style = 'minimal'
--   }

--   local window = api.nvim_open_win(buf, false, config)
--   vim.api.nvim_win_set_option(window, 'winblend', vim.g.ekaput_transparency)
--   vim.api.nvim_win_set_option(window, 'winhl', 'NormalFloat:EKaputBackground')

--   return window

-- end

return utils
