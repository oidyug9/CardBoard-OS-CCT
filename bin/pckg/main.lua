-----------------------------------------------
--
--                      Setup
--
-----------------------------------------------


-- pckg - simple package manager v0.3

local pckg = {} -- register all functions in pckg so it can be required by other program

pckg.IsLive = arg[0] == "pastebin" or arg[0] == "wget" -- checks if program is running ( throught pastebin / wget run {link})
pckg.IsRunning = arg[0] == "pckg" -- checks if its app itself running


-----------------------------------------------
--
--                      prefixes
--
-----------------------------------------------

function pckg.tokenize(cmd) -- tokenize the command (pckg -i package -b branch -v version)
    local tokens = {} -- initilize token table
    local lastToken

    for word in string.gmatch(cmd, "%S+") do -- for words in cmd do:
        local token = {}

        if word:sub(1, 1) == "-" then -- check if the word starts with -
            token.type = 'prefix' -- create  token with type 'prefix' and value of prefix
            token.prefix = word:sub(1)
        end

        if lastToken and lastToken.type=='prefix' then
            lastToken.content = word
        end
    end
end

pckg.tokenize("pckg -a -b test -c -d ooooo -e -f      something alalalalala")

-----------------------------------------------
--
--                      commands
--
-----------------------------------------------







