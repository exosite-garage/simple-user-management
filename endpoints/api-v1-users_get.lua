--#ENDPOINT get /api/v1/users
-- luacheck: globals request response (magic variables from Murano)

local user = UserUtil.currentUserFromHeaders(request.headers)
if user == nil or user.id == nil then
	response.code = 401
	response.message = "Not logged in"
	return
end

if not UserUtil.hasAdmin(user.id) then
	response.code = 403
	response.message = "No permission"
	return
end

local ret = User.listUsers()
if ret.status ~= nil then
	response.code = ret.status
	response.message = ret
else
	return ret
end

-- vim: set ai sw=2 ts=2 :
