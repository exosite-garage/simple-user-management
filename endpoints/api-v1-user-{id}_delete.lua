--#ENDPOINT DELETE /api/v1/user/{id}
-- luacheck: globals request response (magic variables from Murano)

-- Must be logged in
local user = UserUtil.currentUserFromHeaders(request.headers)
if user == nil or user.id == nil then
	response.code = 401
	response.message = "Not logged in"
	return
end

-- Must be self or admin.
if request.parameters.id ~= user.id and not UserUtil.hasAdmin(user.id) then
	response.code = 403
	response.message = "Not allowed"
	return
end

print("Going to delete user id: " .. request.parameters.id)

local ret = User.delete{id = request.parameters.id }
if ret.status ~= nil then
	response.code = ret.status
	response.message = ret
	return
end

response.code = 205
response.message = ''

-- vim: set ai sw=2 ts=2 :
