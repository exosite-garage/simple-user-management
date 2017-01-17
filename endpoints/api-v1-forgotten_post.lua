--#ENDPOINT POST /api/v1/forgotten
-- luacheck: globals request response (magic variables from Murano)

if request.body.email == nil then
	response.code = 400
	response.message = "Email missing"
	return
end

-- Get ID of user
local users = User.listUsers{
	filter= {"email::like::" .. request.body.email}
}
if users.status ~= nil then
	response.code = 404
	response.message = "Users not found"
	return
end

if #users == 0 then
	response.code = 404
	response.message = "User not found"
	return
end

local user = users[1]

-- Generate Token and send email.
-- That links to reset page, which validates token, and asks for new pasword and
-- resets.

-- You could find better token generaters.
math.randomseed(os.time()+os.clock())
local resetToken = Base64.to_base64(math.random() .. os.time() .. math.random())

-- Save the token.
local ret = Keystore.set{key = resetToken, value = user.id}
if ret.status ~= nil then
	response.code = ret.status
	response.message = ret
	return
end
-- Have the Reset Token expire after 24 hours.
Keystore.command{key = resetToken, command = 'EXPIRE', args = { 24*3600 }}

local domain = string.gsub(request.uri, 'https?://(.-/)(.*)', '%1')
local text = "Hi " .. user.email .. ",\n"
text = text .. "Click this link to reset your password\n"
text = text .. "https://" .. domain .. "/resetPassword.html?rt=" .. resetToken;
Email.send({
	from = 'Sample App <mail@exosite.com>',
	to = user.email,
	subject = ("Password reset request from " .. domain),
	text = text
})

-- vim: set ai sw=2 ts=2 :
