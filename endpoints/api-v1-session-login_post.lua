--#ENDPOINT post /api/v1/session-login application/x-www-form-urlencoded
-- luacheck: globals request response (magic variables from Murano)
local ret = User.getUserToken({
	email = request.body.email,
	password = request.body.password
})
if ret.error ~= nil then
	response.code = 401
	response.message = "Auth failed"
else
	response.code = 303
	response.headers = {
		["Set-Cookie"] = "sid=" .. tostring(ret),
		Location = "/profile.html",
	}
	local user = User.getCurrentUser({token = ret})
	if user ~= nil and user.id ~= nil then
		user.token = ret
		response.message = user
	else
		response.code = user.status
		response.message = user
	end
end
-- vim: set ai sw=2 ts=2 :
