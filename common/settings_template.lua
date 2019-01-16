
-- 全局标志
_ENV.dev_sys_log = false -- 服务器系统log开关
_ENV.dev_account_log = false
_ENV.dev_client_log = true

-- 服务配置
local settings = {
    test_mode     = false,     -- 测试模式

    --账号服
    account_conf = {
        account_ip              = '127.0.0.1',  -- 账号服对外ip【需要手动修改】
        account_port            = 9112,         -- 账号登录认证端口
        account_web_port        = 9101,         -- account_web服务监听端口
        account_slave_cout      = 2,            -- 账号服代理个数
        account_web_slave_count = 20,           -- account_web服务代理个数
        console_port            = 9110,         -- 账号服控制台端口
    },
}

-- redis配置
settings.redis_conf = {
    host = '127.0.0.1',
    port = 6379,
    db   = 4,
}

return settings
