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
	return
end

-- Add roles to each user.
for _, luser in ipairs(ret) do
	local roles = User.listUserRoles{id=luser.id}
	if roles.status == nil then
		luser.roles = {'o'}
		for _,role in ipairs(roles) do
			luser.roles[#luser.roles + 1] = role.role_id
		end
	end
end

return ret
-- vim: set ai sw=2 ts=2 :
