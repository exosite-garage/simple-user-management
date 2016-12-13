--#ENDPOINT post /api/v1/session application/x-www-form-urlencoded
-- luacheck: globals request response (magic variables from Murano)
local ret = User.getUserToken({
	email = request.body.email,
	password = request.body.password
})
print(to_json(ret))
if ret.error ~= nil then
	response.code = 401 --ret.status_code
	response.message = "Auth failed"
else
	response.headers = {
		["Set-Cookie"] = "sid=" .. tostring(ret),
		["Location"] = "/",
	}
	--response.message = {["token"] = ret}
	response.code = 303
end
-- vim: set ai sw=2 ts=2 :
