local config = {
  error_sign = '',
  warning_sign = '',
  information_sign = '',
  hint_sign = '',
  transparency = 25,
  borders = true,
  enabled = true,
}

setmetatable(config, { __index = config.defaults })

return config
