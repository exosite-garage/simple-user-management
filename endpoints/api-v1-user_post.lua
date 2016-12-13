--#ENDPOINT POST /api/v1/user
-- luacheck: globals request response (magic variables from Murano)
local email = request.body.email
local name = request.body.name
local password = request.body.password

local ret = User.createUser({
  email = email,
  name = name or email,
  password = password
})
if ret.status_code ~= nil then
  response.code = ret.status_code
  response.message = ret.message
else
  local domain = string.gsub(request.uri, 'https?://(.-/)(.*)', '%1')
  local text = "Hi " .. email .. ",\n"
  text = text .. "Click this link to verify your account:\n"
  text = text .. "https://" .. domain .. "/api/v1/verify/" .. ret;
  Email.send({
    from = 'Sample App <mail@exosite.com>',
    to = email,
    subject = ("Signup on " .. domain),
    text = text
  })
end

-- vim: set ai et sw=2 ts=2 :
