assert(arg[1] ~= nil, "No command given")

local PIM = {}

PIM.Eval = "PIMS_PATH"

local execute = os.execute
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

local function passert(fn)
    if type(fn) ~= "function" then return end
    local ok, err = pcall(fn())
    if not ok then
       error("A error occured, stack traceback:\n"..err)
    end
end

PIM._VERSION = "v1.0"
PIM.info = "PIM "..PIM._VERSION.."\n\n"
PIM.usage = [[

atr - add PIM_PATH to papel registry (already setted by default) (no arguments)

version - shows version of PIM (no arguments)

help - shows a list of commands

pims - shows all PIMs (no arguments)

lpim - adds a LPIM on PIM folder (one argument)
     |
     Options:
        none - creates a lpim
        -c  - changes the LPIM (one argument)
        -s  - shows the current lpim (no arguments)

apim - adds a PIM on current LPIM (one argument)

ipim - makes a pim

dpim - deletes a PIM on current LPIM (one argument)

dlpim  - deletes a LPIM (one argument)

]]

local path = readf("REGs/PIM_PATH")
local curr_lpim = readf("REGs/PIM_CURR_LPIM")

if arg[1] == "help" then
    print(PIM.info..PIM.usage)
elseif arg[1] == "version" then
    print(PIM._VERSION)
elseif arg[1] == "atr" then
    passert(edit("REGs/PIM_PATH", "./PIMs"))
elseif arg[1] == "pims" then
    passert(execute("ls "..PIM.path))
elseif arg[1] == "lpim" then
    assert(arg[2] ~= nil, "No name given")
    if arg[2] == "-c" then
        assert(arg[3] ~= nil, "No name given")
        passert(edit("REGs/PIM_CURR_LPIM", arg[3]))
    elseif arg[2] == "-s" then
        print(curr_lpim)
    else
        passert(execute("mkdir "..path.."/"..arg[2]))
        passert(edit("REGs/PIM_CURR_LPIM", path.."/"..arg[2]))
        print("LPIM added")
    end
elseif arg[1] == "apim" then
    assert(arg[2] ~= nil, "No name given")
    local filetouse = readf("./"..arg[2])
    if not filetouse then
        error("No such file '"..arg[2].."'")
    end
    passert(edit(path.."/"..curr_lpim.."/"..arg[2], filetouse))
    print("PIM added")
elseif arg[1] == "ipim" then
    assert(arg[2] ~= nil, "No name given")
    local file = readf(path.."/"..curr_lpim.."/"..arg[2])
    if not file then
        error("No such file '"..arg[2].."'")
    end
    passert(edit("./"..arg[2], file))
    print("Done")
elseif arg[1] == "dpim" then
    assert(arg[2] ~= nil, "No name given")
    passert(execute("rm -rf "..path.."/"..curr_lpim.."/"..arg[2]))
    print("PIM deleted")
elseif arg[1] == "dlpim" then
    assert(arg[2] ~= nil, "No name given")
    passert(execute("rm -rf "..path.."/"..arg[2]))
    print("LPIM deleted")
else
    error("Invalid command '"..arg[1].."'")
end