
--- 常量
-- @module constant

local M = {}

-- 性别
M.GENDER = {
    UNKOWN  = 0,
    MAN     = 1,
    WOMAN   = 2,
}

-- 平台类型(sdk)
M.PLATFORM = {
    ANDRIOD = 0, -- 安卓
    IOS     = 1, -- 苹果
    INNER   = 1, -- 未知
}

-- 渠道类型
M.CHANNEL = {
    INNER   = 0,
    -- todo: 其他渠道
}

-- 日志级别
M.LOG_LEVEL = {
    LOG_DEFAULT   = 1,
    LOG_TRACE     = 1,
    LOG_DEBUG     = 2,
    LOG_INFO      = 3,
    LOG_WARN      = 4,
    LOG_ERROR     = 5,
    LOG_FATAL     = 6,
}

-- 错误码
M.ERRORCODE =
{
    success             = {0, "success"},           -- 成功
    sign_failed         = {1, "sign_error"},        -- 校验签名失败
    params_failed       = {2, "invalid_param"},     -- 参数校验失败
    user_not_found      = {3, "user_not_found"},    -- 用户不存在
    account_not_found   = {5, "account_not_found"}, -- 账号不存在
    not_online          = {6, "not_online"}, -- 用户在线
    cmd_not_found       = {7, "cmd_not_found"},     -- 命令不存在
    server_id_error     = {8, "server_id_error"},   -- 服ID错误
    server_status_error = {9, "server_status_error"}, -- 服务器状态错误
    json_datas_error    = {10, "json_datas_error"}, -- json数据有错
    appid_not_found     = {13, "appid_not_found"},  -- appid找不到
    account_had_exist   = {14, "account_had_exist"} -- 注册时,用户已存在
}

-- 请求类型
M.REQ_TYPE = {
    RT_REGISTER         = 1,
    RT_LOGIN            = 2,
    RT_MODIFYPASSWORD   = 3,
    RT_COMMITUSERDATA   = 4,
}

return M
