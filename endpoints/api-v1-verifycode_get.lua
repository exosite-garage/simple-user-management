--#ENDPOINT GET /api/v1/verify/{code}
-- luacheck: globals request response (magic variables from Murano)
local ret = User.activateUser({code = request.parameters.code})
if ret == 'OK' then
	-- TODO: Don't return HTML; redirect to page.
	response.headers["Content-type"] = "text/html"
	response.message = '<html><head></head><body>Signed up successfully. <a href="/#/login">Log in</a></body></html>'
else
	response.message = 'Sign up failed. Error: ' .. ret.message
end

-- vim: set ai sw=4 ts=4 :
