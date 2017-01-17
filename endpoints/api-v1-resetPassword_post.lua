--#ENDPOINT POST /api/v1/resetPassword
-- luacheck: globals request response (magic variables from Murano)

if request.body.resetToken == nil then
	response.code = 400
	response.message = "Missing reset token"
	return
end

if request.body.password == nil then
	response.code = 400
	response.message = "Missing new password"
	return
end

local found = Keystore.get{key = request.body.resetToken}
if found.status ~= nil then
	response.code = found.status
	response.message = found
	return
end

local ret = User.resetUserPassword{
	id = found.value,
	password = request.body.password
}
if ret.status ~= nil then
	response.code = ret.status
	response.message = ret
	return
end

Keystore.delete{key = request.body.resetToken}

return ret

-- vim: set ai sw=2 ts=2 :
