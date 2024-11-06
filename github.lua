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

    
print'hello skid'
