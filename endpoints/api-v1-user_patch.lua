--#ENDPOINT PATCH /api/v1/user/{email}
-- luacheck: globals request response (magic variables from Murano)
local user = currentUserFromHeaders(request.headers)
if user ~= nil then
  User.updateUserStorage({id = user.id, ["key values"] = request.body})
  User.createUserStorage({id = user.id, ["key values"] = request.body})
end

-- vim: set ai sw=2 ts=2 :
