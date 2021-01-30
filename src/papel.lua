assert(arg[1] ~= nil, "No command given")
--require "lib/class"
local Papel = {}

local exit = os.exit
local write = io.write
local execute = os.execute
local read = io.read
local open = io.open

local function passert(fn)
   if type(fn) ~= "function" then return end

   local ok, err = pcall(fn())
   if not ok then
      error("A error occured, stack traceback:\n"..err)
   end
end

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

Papel._VERSION = "v1.0"

local currlang = readf("REGs/LANG")

Papel.Arg = {}
Papel.Arg.info = "Papel "..Papel._VERSION
Papel.Arg.usage = [[

version - displays version of papel (no arguments)

help - display a list of commands (one to two aguments)
     |
   Options:
      none - displays all commands and options
      -c - commands

create - starts a new project (one to four arguments)
       |
   Flags: (Must be the 3th argument.)
      none - makes normally
      -jof - Makes just one file, perfect for small projects.


lang - manage the current programming language you are using (one to two arguments)
     |
     Options:
     none - shows the current lang
     -cl  - changes the current language to another (one argument)

]]

if arg[1] == "help" then
   if arg[2] == "-c" then
      print(Papel.Arg.info..'\n\n'..[[version - displays version of papel (no arguments)

help - display a list of commands (one to two aguments)

create - starts a new project

lang - manage the current programming language you are using (one to three arguments)]])
   elseif arg[2] == nil then
      print(Papel.Arg.info.."\n\n"..Papel.Arg.usage)
   end
elseif arg[1] == "version" then
   print(Papel._VERSION)
elseif arg[1] == "create" then
   assert(arg[2] ~= nil, "No name passed")
   print(Papel.Arg.info.."\n\n")
   if arg[3] == "-jof" then
      print("Creating a base to J.O.F Project '"..arg[2].."'")
      passert(execute("touch "..arg[2].."."..currlang))
      passert(edit('./'..arg[2]..".lua", "return 'Hello World!'"))
      print("Project made.")
      exit()
   end
      while true do
         write("Are you sure create project '"..arg[2].."' (Y/N): ")
         local c = read()
         if c == "Y" then
            print("Creating a base for project '"..arg[2].."'")
            passert(execute('mkdir '..arg[2]..' && cd '..arg[2]..' && mkdir source && cd source && touch ./main.'..currlang..' && mkdir mods && cd mods && touch ./module.'..currlang..' && cd ~/'))
            print("Project made.")
            break
         elseif c == "N" then
            exit()
         else
            error("Invalid choice")
         end
      end
elseif arg[1] == "lang" then
   if arg[2] == "-cl" then
      assert(arg[3] ~= nil, "No name passed")
      passert(edit("./REGs/LANG", arg[3]))
   else
      print(currlang)
   end
else
   error("Invalid command '"..arg[1].."'")
end