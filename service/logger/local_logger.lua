--- logger 服务
-- 本地日志处理模块
-- @module logger.local_logger

local skynet    = require "skynet"
local cluster   = require "cluster"
local json      = require "cjson"
local date      = require "date"
local config_logger = require "logger.config_logger"
local utils     = require "utils"
local settings  = require "settings"
local json      = require "cjson"
local LOG_TYPE  = config_logger.log_index

require "skynet.manager"
require "logger_api"

skynet.register_protocol {
    name = "busi_logger",
    id = 0,
    pack = function (...)
        local t = {...}
        for i,v in ipairs(t) do
            t[i] = tostring(v)
        end
        return table.concat(t," ")
    end,
    unpack = skynet.unpack,
}

local CMD = {}
CMD.log_box = {}

local function get_log_str(prefix, appid, t)
    return date.format(date.second()) .. "|" ..  prefix .. "|" .. appid .. "|" .. json.encode(t)
end

function CMD.log(logtype, prefix, appid, data)
    if not CMD.log_box[logtype] then
        skynet.error("cannot find bussiness by type: ", logtype)
        return
    end
    local str = get_log_str(prefix, appid, data)
    skynet.send(config_logger.service_name[logtype], "busi_logger", str)
end

-- 玩家注册日志
function CMD.log_register(appid, account, password, email, phone)
    local data = {
        account     = account,
        password    = password,
        email       = email or "",
        phone       = phone or "",
    }
    CMD.log(LOG_TYPE.LOG_REGISTER, 'register', appid, data)
end

-- 玩家登录日志
function CMD.log_login(appid, account, password)
    local data = {
        account     = account,
        password    = password,
    }
    CMD.log(LOG_TYPE.LOG_LOGIN, 'login', appid, data)
end

-- 玩家修改密码日志
function CMD.log_modifypassword(appid, account, oldpassword, newpassword)
    local data = {
        account     = account,
        oldpassword = oldpassword,
        newpassword = newpassword,
    }
    CMD.log(LOG_TYPE.LOG_MODIFYPASSWORD, 'modifypassword', appid, data)
end

-- 玩家提交用户数据日志
function CMD.log_commituserdata(appid, account, data)
    local data = {
        account = account,
        data    = data,
    }
    CMD.log(LOG_TYPE.LOG_COMMITUSERDATA, 'commituserdata', appid, data)
end

-- end business logger --

function CMD.init()
    for key,value in pairs(config_logger.local_service) do
        skynet.launch("busilogger", value)
        CMD.log_box[key] = 1
    end
end

local traceback = debug.traceback
skynet.start(function()
    skynet.dispatch("lua", function(_, _, command, ...)
    local f = CMD[command]
    if not f then
        skynet.error(("local_logger unhandled message(%s)"):format(command))
        return
    end

    local ok, ret = xpcall(f, traceback, ...)
        if not ok then
            skynet.error(("local_logger handle message(%s) failed : %s"):format(command, ret))
        end
    end)
    skynet.register("." .. SERVICE_NAME)
end)
