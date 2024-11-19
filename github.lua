if not game:IsLoaded() then
    game.Loaded:Wait()
end

function request(options)
	assert(type(options) == "table", "invalid argument #1 to 'request' (table expected, got " .. type(options) .. ") ", 2)
	local Event = Instance.new("BindableEvent")
	local RequestInternal = game:GetService("HttpService").RequestInternal
	local Request = RequestInternal(game:GetService("HttpService"), options)
	local Start = Request.Start
	local Response
	Start(Request, function(state, response)
		Response = response
		Event:Fire()
	end)
	Event.Event:Wait()
	return Response
end

function HttpGet(url)
	assert(type(url) == "string", "invalid argument #1 to 'httpget' (string expected, got " .. type(url) .. ") ", 2)
    local response = request({
        Url = url;
        Method = "GET";
    }).Body
	task.wait() 
	return response
end

function HttpGetAsync(...)
    local b = table.concat({...}, " ")
 
    local a = {
        Url = "http://localhost:2024/httpget",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "text/plain"
        },
        Body = b
    }
    
    return request(a).Body
end

function info(...)
    local b = table.concat({...}, " ")
 
    local a = {
        Url = "http://localhost:2024/info",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "text/plain"
        },
        Body = b
    }
    
    return request(a).Body
end

function setclipboard(...)
    local b = table.concat({...}, " ")
 
    local a = {
        Url = "http://localhost:2024/setclipboard",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "text/plain"
        },
        Body = b
    }
    
    return request(a).Body
end

function loadstring(src, chunkname)
    local module = game.CoreGui.RobloxGui.Modules.Common.Text
    module = module:Clone()
    module.Name = "nyxss"
    module.Parent = game.CoreGui
 
    local options = {
        Url = "http://localhost:2024/loadstring",
        Method = "POST",
        Headers = {
            ["Content-Type"] = "text/plain"
        },
        Body = "return function(...) " .. src .. "\nend"
    }
 
    request(options)

    module.Name = if chunkname then tostring(chunkname) else "nyxss"
    module.Parent = nil
    local woked, func = pcall(require, module)
    module:Destroy()
    if woked then
        setfenv(func, getfenv(1))
        return function(...)
            local worked, stuff = pcall(func, ...)
            if not worked then
                task.spawn(function()
                    error(stuff, 2)
                end)
                return nil, stuff
            else
                return stuff
            end
        end
    else
        return nil, func
    end
end

	local wrappercache = setmetatable({}, {__mode = "k"})

wrap = function(real)
	for w, r in next, wrappercache do
		if r == real then
			return w
		end
	end

	if type(real) == "userdata" then
		local fake = newproxy(true)
		local meta = getmetatable(fake)

		meta.__index = function(s, k)
			if k == "HttpGet" or k == "HttpGetAsync" then
				return function(self, url)
					local s, r = nil, nil

					game:GetService("HttpService"):RequestInternal({
						Url = url,
						Method = "GET"
					}):Start(function(a, b)
						s, r = a, b
					end)

					repeat task.wait() until (s ~= nil or r ~= nil)
					return r.Body
				end
			elseif k == "GetObjects" then
				return function(self, assetid)
					assert(
						typeof(assetid) == "string" or assetid:find("rbxassetid://"),
						"arg #1 not a valid asset id."
					)

					return {insert_service:LoadLocalAsset(assetid)}
				end
			end

			return typeof(real[k]) == "Instance" and real[k] or wrap(real[k])
		end

		meta.__newindex = function(s, k, v)
			real[k] = v
		end

		meta.__tostring = function(s)
			return tostring(real)
		end

		wrappercache[fake] = real
		return (typeof(real) == "Instance" and real.ClassName ~= "DataModel") and real or fake
	elseif typeof(real) == "Instance" then
		return real
	elseif type(real) == "function" then
		local fake = function(...)
			local args = unwrap{...}
			local results = wrap{real(unpack(args))}
			return unpack(results)
		end
		wrappercache[fake] = real
		return fake
	elseif type(real) == "table" then
		local fake = {}
		for k, v in next, real do
			fake[k] = (typeof(v) == "Instance" and v.ClassName ~= "DataModel") and v or wrap(v)
		end
		return fake
	else
		return real
	end
end

unwrap = function(wrapped)
	if type(wrapped) == "table" then
		local real = {}
		for k, v in next, wrapped do
			real[k] = unwrap(v)
		end
		return real
	else
		local real = wrappercache[wrapped]
		if real == nil then
			return wrapped
		end
		return real
	end
end

game = wrap(Game)
