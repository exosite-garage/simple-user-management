--#ENDPOINT PUT /api/v1/user/{email}/profile
-- luacheck: globals request response (magic variables from Murano)

-- Can only put if email == current_user email.
--
-- TODO: ask this:
-- So, if I setup roles&perms will that check happen automatically? or do I have to
-- check it myself?

-- Get ID of user
local users = User.listUsers{
	filter= {"email::like::" .. request.parameters.email}
}
if users.status_code ~= nil then
	response.code = users.status_code
	response.message = users
	return
end

if #users == 0 then
	response.code = 404
	response.message = "User not found"
	return
end

local user = users[1]

-- Do we need to update their name?
if request.body.name ~= user.name then
	local ret = User.updateUser{
		id = user.id,
		name = request.body.name
	}
	if ret.status_code ~= nil then
		response.code = ret.status_code
		response.message = ret
		return
	end
end

-- copy over just the bits we save to UserData
local ud = {}
ud.location = request.body.location or ""
ud.bio = request.body.bio or ""

ud.id = user.id
print("Writing : " .. table.dump(ud))

local ret = User.createUserData(ud)
if ret.status ~= nil then
	print("Create fails")
	response.code = ret.status
	response.message = ret
	return
end

ret = User.updateUserData(ud)
if ret.status ~= nil then
	print("Update fails")
	response.code = ret.status
	response.message = ret
	return
end


return 'ok'

-- vim: set ai sw=2 ts=2 :

