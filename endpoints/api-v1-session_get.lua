--#ENDPOINT get /api/v1/session
-- luacheck: globals request response (magic variables from Murano)
local user = UserUtil.currentUserFromHeaders(request.headers)
if user ~= nil and user.id ~= nil then
    return user
end
response.code = 400
response.message = "Session invalid"
-- vim: set ai sw=2 ts=2 :
