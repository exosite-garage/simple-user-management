--#ENDPOINT GET /api/v1/verify/{code}
-- luacheck: globals request response (magic variables from Murano)
local ret = User.activateUser({code = request.parameters.code})
if ret == 'OK' then
	response.headers["Location"] = "/profile.html"
	response.code = 303
else
	response.code = 401
	response.message = 'Sign up failed. Error: ' .. ret.message
end

-- vim: set ai sw=4 ts=4 :
