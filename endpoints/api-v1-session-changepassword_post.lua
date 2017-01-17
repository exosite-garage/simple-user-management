--#ENDPOINT POST /api/v1/session/changepassword
-- luacheck: globals request response (magic variables from Murano)

-- Must be logged in
local current = UserUtil.currentUserFromHeaders(request.headers)
if current == nil or current.id == nil then
	response.code = 401
	response.message = "Not logged in"
	return
end

if request.body.oldpassword ~= nil and request.body.password ~= nil then
	local ret = User.updateUser{
		id = current.id,
		password = request.body.password,
		original_password = request.body.oldpassword
	}
	if ret.error ~= nil then
		response.code = ret.status
		response.message = {
			message = "Cannot change password",
			details = ret
		}
		return
	end
end
-- vim: set ai sw=2 ts=2 :
