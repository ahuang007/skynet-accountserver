--- logger 服务
-- 日志配置表
-- @module logger.config_logger

local skynet = require "skynet"
local config = {}

--业务日志
config.log_index =
{
    LOG_REGISTER        = 1, -- 注册
    LOG_LOGIN           = 2, -- 登录
    LOG_MODIFYPASSWORD  = 3, -- 修改密码
    LOG_COMMITUSERDATA  = 4, -- 提交用户数据
}

--业务日志对应服务名
config.service_name =
{
    [config.log_index.LOG_REGISTER]         = ".account_register",
    [config.log_index.LOG_LOGIN]            = ".account_login",
    [config.log_index.LOG_MODIFYPASSWORD]   = ".account_modifypassword",
    [config.log_index.LOG_COMMITUSERDATA]   = ".account_commituserdata",
}

-- 游戏逻辑服务
config.local_service =
{
    [config.log_index.LOG_REGISTER]         = ".account_register busilog register",
    [config.log_index.LOG_LOGIN]            = ".account_login busilog login",
    [config.log_index.LOG_MODIFYPASSWORD]   = ".account_modifypassword busilog modifypassword",
    [config.log_index.LOG_COMMITUSERDATA]   = ".account_commituserdata busilog commituserdata",
}

return config

