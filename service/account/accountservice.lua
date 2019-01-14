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
require "logger_api"

local CMD           = {}

function CMD.init()
    cluster.register("accountservice")
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
