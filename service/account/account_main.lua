--- account 服务
-- account 服务入口
-- @module account

local skynet = require 'skynet.manager'
local cluster = require "cluster"
local settings = require 'settings'

skynet.start(function ()
    skynet.uniqueservice('debug_console', settings.account_conf.console_port)
    skynet.uniqueservice('redis')

    -- 业务日志服务
    local local_logger = assert(skynet.uniqueservice('local_logger'), 'init local_logger failed')
    skynet.send(local_logger,"lua", "init")

    local accountservice = skynet.newservice("accountservice")
    skynet.name(".rankservice", accountservice)
    skynet.call(accountservice, "lua", "init")
    skynet.name(".account_web", skynet.newservice("account_web"))

    cluster.open "accountnode"
    skynet.exit()
end)

