cc = cc or {}

-- cc.log
cc.log = function(...)
    print(string.format(...))
end

-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    cc.log("----------------------------------------")
    cc.log("LUA ERROR: " .. tostring(msg) .. "\n")
    cc.log(debug.traceback())
    cc.log("----------------------------------------")
end

-- load lua file under a folder, include subfolders
function loadLua(name)
    local path
    if CCDevice:getPlatform() == cc.PLATFORM_ANDROID then
        -- XXX: in Android, looks like we need copy script to files dir first, this is not done
        path = CCUtils:getInternalStoragePath() .. "/script"
    else
        path = CCFileUtils:sharedFileUtils():fullPathForFilename("script");
    end
    for entry in lfs.dir(path .. "/" .. name) do
        if entry ~= "." and entry ~= ".." and entry ~= "__init__.lua" and string.find(entry,".lua") ~= nil then
            local s, n = string.gsub(entry, ".lua+", function(s) return "" end)
            local fullpath = path .. "/" .. name .. "/" .. s
            require(fullpath)
        end
    end
end

-- load all cocos core lua
loadLua("cocos")