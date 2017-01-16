--#ENDPOINT PUT /api/v1/user/{id}
-- luacheck: globals request response (magic variables from Murano)

-- Must be logged in
local current = UserUtil.currentUserFromHeaders(request.headers)
if current == nil or current.id == nil then
	response.code = 401
	response.message = "Not logged in"
	return
end

-- Must be self or admin.
if request.parameters.id ~= current.id and not UserUtil.hasAdmin(current.id) then
	response.code = 403
	response.message = "Not allowed"
	return
end


-- Check for name change.
if request.body.name ~= nil then
	local user = User.getUser{id = request.parameters.id}
	if user.status ~= nil then
		response.code = user.status
		response.message = {
			message = "cannot find user",
			details = user
		}
		return
	end

	if user.name ~= request.body.name then
		local ret = User.updateUser{
			id = request.parameters.id,
			name = request.body.name
		}
		if ret.status ~= nil then
			response.code = ret.status
			response.message = {
				message = "Cannot update user name",
				details = ret
			}
			return
		end
	end
end

-- Check for Info changes
if request.body.location ~= nil or request.body.bio ~= nil then
	-- copy over just the bits we save to UserData
	local ud = {}
	ud.location = request.body.location or ""
	ud.bio = request.body.bio or ""

	-- Make sure keys exist.
	UserUtil.checkUserDataKeys(request.parameters.id, ud)

	ud.id = request.parameters.id

	local ret = User.updateUserData(ud)
	if ret.status ~= nil then
		response.code = ret.status
		response.message = {
			message = "Cannot update details",
			details = ret
		}
		return
	end
end

-- Check for role changes.
if request.body.roles ~= nil and UserUtil.hasAdmin(current.id) then
	local toadd = request.body.roles.add or {}
	local todel = request.body.roles.del or {}

	for _, delme in ipairs(todel) do
		local ret = User.deassignUser{
			id = request.parameters.id,
			role_id = delme
		}
		if ret.status ~= nil then
			response.code = ret.status
			response.message = {
				message = "cannot delete role: " .. tostring(delme),
				details = ret
			}
		end
	end

	for _, addme in ipairs(toadd) do
		if addme == 'admin' then
			local ret = User.assignUser{
				id = request.parameters.id,
				roles = {
					{
						role_id = 'admin',
						parameters = {
							{ name='enabled', value = '1' }
						}
					}
				}
			}
			if ret.status ~= nil then
				response.code = ret.status
				response.message = {
					message = "cannot add role: " .. tostring(addme),
					details = ret
				}
			end
		end
	end
end

return 'ok'
-- vim: set ai sw=2 ts=2 :
