
----------------------------------- case 1 -----------------------------------
do
  local a = "one"
  local z = "one half"
end

do
  local b = "two"  -- @todo: "a" recognized!
end

----------------------------------- case 2 -----------------------------------

---
-- Merges associative arrays.
local function merge(base, ext, ...)
  if ext then
    for k, v in pairs(ext) do
      base[k] = v
    end
    local x = 2    -- @todo: "(for gen)" is recognized here!
    return merge(base, ...)
  else
    return base
  end
end
