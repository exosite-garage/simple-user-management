--#ENDPOINT post /api/v1/session
-- luacheck: globals request response (magic variables from Murano)
local ret = User.getUserToken({
  email = request.body.email,
  password = request.body.password
})
if ret ~= nil and ret.status_code ~= nil then
  response.code = ret.status_code
  response.message = ret.message
else
  response.headers = {
    ["Set-Cookie"] = "sid=" .. tostring(ret)
  }
  response.message = {["token"] = ret}
end
-- vim: set ai sw=2 ts=2 :
