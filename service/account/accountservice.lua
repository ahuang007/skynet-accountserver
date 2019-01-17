--- account 服务
-- 账号服务
-- @module account.accountservice

local skynet    = require "skynet"
local crypt     = require "crypt"
local settings  = require 'settings'
local constant  = require 'constant'
local utils     = require 'utils'
local sharedata = require "sharedata"
local cluster   = require "cluster"
local app_config = require "app_config"
local redisx    = require "redisx"
require "logger_api"

local CMD           = {}

-- uid 唯一
local uid_key = "max_uid"
function CMD.init()
    cluster.register("accountservice")
    if not redisx.exists(uid_key) then
        redisx.setstring(uid_key, math.random(10000, 99999))
    end
end

skynet.start(function ()
    skynet.dispatch("lua", function(session, source, command, ...)
        if dev_account_log then
            skynet.error('command: ', command, ...)
        end
        local f = CMD[command]
        if f then
            if session ~= 0 then
                skynet.retpack(f(...))
            else
                f(...)
            end
        else
            skynet.error("unknow command : ", command, source)
            if session ~= 0 then
                skynet.ret(false, "unknow command : " .. command)
            end
        end
    end)
end)
