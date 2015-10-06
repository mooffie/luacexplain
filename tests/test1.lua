
do
  local a = "one"
  local z = "one half"
end

do
  local b = "two"  -- verify that the register is labeled "?b", not "a".
end

local function func()
  for k, v in pairs(ext) do
    base[k] = v
  end
  local x = 2  -- verify that the register is labeled "?x", not "(for generator)".
end
