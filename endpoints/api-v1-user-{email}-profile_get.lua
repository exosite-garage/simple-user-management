--#ENDPOINT GET /api/v1/user/{email}/profile
-- luacheck: globals request response (magic variables from Murano)

-- Any logged in user can get the profile of another.
local user = UserUtil.currentUserFromHeaders(request.headers)
if user == nil or user.id == nil then
	response.code = 401
	response.message = "Not logged in"
	return
end

-- Get ID of user
local users = User.listUsers{
	filter= {"email::like::" .. request.parameters.email}
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

user = users[1]

-- Get user data for user.
local ud = User.listUserData{id=user.id}

-- Copy over bits from each
local result = {}
result.name = user.name or user.email
result.email = user.email
result.creation_date = user.creation_date
result.location = ud.location or ""
result.bio = ud.bio or ""

return result

-- vim: set ai sw=2 ts=2 :
