local M = {}

-- TODO: implement
function M.get_lang_list() return {'en', 'ua'} end

function M.translate(text, from_lng, to_lng)
  local cjson = require 'cjson'
  local request = require 'http.request'
  local utils = require 'http.util'

  local base = 'https://translate.googleapis.com'
  local params = {
    client = 'gtx',
    sl = from_lng,
    tl = to_lng,
    dt = 't',
    q = text,
  }
  local url = base .. '/translate_a/single?' .. utils.dict_to_query(params)
  local _, stream = request.new_from_uri(url):go()
  local ok, result = pcall(function()
    local b = cjson.decode(stream:get_body_as_string())
    return b[1][1][1]
  end)
  if ok then return result end
end

function M.setup() end

return M
