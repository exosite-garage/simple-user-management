-- luacheck: ignore UserUtil

UserUtil = {}

-- determine the current user from the session information
-- stored in webservice or websocket request headers.
-- returns user table or nil if no user is contained
-- in headers
function UserUtil.currentUserFromHeaders(headers)
	local _
	local sid = headers['x-token']
	if headers['x-token'] == nil then
		if type(headers.cookie) ~= "string" then
			return nil
		end
		_, _, sid = string.find(headers.cookie, "sid=([^;]+)")
		if type(sid) ~= "string" then
			return nil
		end
	end
	local user = User.getCurrentUser{token = sid}
	if user ~= nil and user.id ~= nil then
		user.token = sid
		local roles = User.listUserRoles{id=user.id}
		if roles.status == nil then
			user.roles = {}
			for _,role in ipairs(roles) do
				user.roles[#user.roles + 1] = role.role_id
			end
		end
		return user
	end
	return nil
end


-- Check if this user has Admin permissions
function UserUtil.hasAdmin(userID)
	local roles = User.listUserRoles{id=userID}
	if roles.status ~= nil then
		return false
	end
	for _, role in ipairs(roles) do
		if role.role_id == "admin" then
			return true
		end
	end

	return false
end

-- Check to see if all the keys exist in the UserData for #id
-- If not, create those keys with the values given
function UserUtil.checkUserDataKeys(id, keys)
	local oud = User.listUserData{id=id}
	local cud = {}
	for key, def in pairs(keys) do
		if oud[key] == nil then
			cud[key] = def
		end
	end

	if #cud > 0 then
		cud.id = id
		local ret = User.createUserData(cud)
		if ret.status ~= nil then
			return false, ret
		end
	end
	return true
end

-- vim: set ai sw=2 ts=2 :
