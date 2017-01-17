--#ENDPOINT get /api/v1/session
-- luacheck: globals request response (magic variables from Murano)
local user = UserUtil.currentUserFromHeaders(request.headers)
if user ~= nil and user.id ~= nil then
	response.headers = {
		["Cache-Control"] = 'no-cache',
	}		
	response.message = user
else
	response.code = 400
	response.message = "Session invalid"
end
-- vim: set ai sw=2 ts=2 :
