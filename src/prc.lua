assert(arg[1] ~= nil, "No command given")
local PRC = {}

local exit = os.exit
local write = io.write
local execute = os.execute
local upper = string.upper
local open = io.open

local function edit(file, cont)
    local f = io.open(file, 'w+')
    f:write(cont)
    f:close()
end

local function readf(path)
    local file = open(path, "rb")
    if not file then return nil end
    local content = file:read "*a"
    file:close()
    return content
end

local function existf(path)
    local file = open("./"..path, "rb")
    if not file then return nil else return true end
end

local function passert(fn)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn())
    if not ok then
       error("A error occured, stack traceback:\n"..err)
    end
end


PRC._VERSION = "v1.0"

PRC.info = "PRC "..PRC._VERSION
PRC.usage = PRC.info..[[
version - shows prc version

help - shows a list of commands

regs - shows all papel registery

areg - creates a registery

dreg - deletes a registery

ereg - edits a registry

vreg - see value of a registry
]]

if arg[1] == "version" then
    print(PRC._VERSION)
elseif arg[1] == "help" then
    print(PRC.usage)
elseif arg[1] == "regs" then
    passert(execute("ls ./REGs"))
elseif arg[1] == "areg" then
    assert(arg[2] ~= nil, "No name passed")
    if existf("./REGs/"..arg[2]) then
        error("Registry already exist")
    end
    passert(edit("./REGs/"..upper(arg[2]), ""))
elseif arg[1] == "dreg" then
    assert(arg[2] ~= nil, "No name passed")
    if existf("./REGs/"..upper(arg[2])) then
        passert(execute("rm -rf ./REGs/"..upper(arg[2])))
    else
        error("File "..arg[2].." dont exist")
    end
elseif arg[1] == "ereg" then
    assert(arg[2] ~= nil, "No name passed")
    if existf("./REGs/"..upper(arg[2])) then
        passert(edit("./REGs/"..upper(arg[2]), arg[3]))
    else
        error("File "..arg[2].." dont exist")
    end
elseif arg[1] == "vreg" then
    assert(arg[2] ~= nil, "No name passed")
    if existf("./REGs/"..upper(arg[2])) then
        print(readf("./REGs/"..upper(arg[2])))
    else
        error("Registry dont exist")
    end
else
    error("Invalid command '"..arg[1].."'")
end