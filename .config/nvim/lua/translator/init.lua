local M = {}

-- TODO: implement for langcode completion
function M.get_lang_list() return {'en', 'ua'} end

function M.translate(text, ...)
  local args = {...}
  local from_lng, to_lng
  if #args == 1 then
    from_lng, to_lng = 'auto', args[1]
  elseif #args == 2 then
    from_lng, to_lng = args[1], args[2]
  else
    return
  end

  local cjson = require 'cjson'
  local request = require 'http.request'
  local utils = require 'http.util'

  local base = 'https://translate.googleapis.com'
  local path = '/translate_a/single'
  local params = {
    client = 'gtx',
    sl = from_lng,
    tl = to_lng,
    dt = 't',
    q = text,
  }
  local url = string.format('%s%s?%s', base, path, utils.dict_to_query(params))
  local _, stream = request.new_from_uri(url):go()
  local ok, result = pcall(function()
    local b = cjson.decode(stream:get_body_as_string())
    return b[1][1][1]
  end)
  if ok then return result end
end

function M.setup()
  vim.cmd('source ' .. vim.fn.expand('%:p:h') .. '/lua/translator/setupcmd.vim')
end

return M
