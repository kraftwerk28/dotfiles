setmetatable({}, {
  __add = function(self, other)
    for k, v in pairs(other) do
      self[k] = v
    end
  end,
})
