--- account http 服务
-- @module account.account_web

local skynet        = require "skynet"
require 'skynet.manager'
local socket        = require "socket"
local httpd         = require "http.httpd"
local sockethelper  = require "http.sockethelper"
local urllib        = require "http.url"
local utils         = require "utils"
local constant      = require "constant"
local ErrorCode     = constant.ERRORCODE
local json          = require "json"
local settings      = require 'settings'
local crypt         = require 'crypt'
local md5           = require 'md5'

require "logger_api"

local mode = ...
local accountservice

if mode == "agent" then

local function response(id, statuscode, bodyfunc, header)
    if not header then header = {} end
    header["Access-Control-Allow-Origin"] = "*" -- 解决跨域问题

    local ok, err = httpd.write_response(sockethelper.writefunc(id), statuscode, bodyfunc, header)
    if not ok then
        -- if err == sockethelper.socket_error , that means socket closed.
        INFO(string.format("fd = %d, %s", id, err))
    end
end

--[[
账号服文档
ip:192.168.1.201
port: 9100
1 注册账号 http://192.168.1.201:9100/register?
    {"cmd":"register", "appid":1, data:{"uid":1001, "name":"andy", "headIcon":"", "score":99}
2 账号登录 http://192.168.1.201:9100/login?
    {"cmd":"login", "appid":1, data:{"uid":1001, "startindex":1, "endindex":100}
3 修改密码 http://192.168.1.201:9100/modifyPassword?
    {"cmd":"modifyPassword", "appid":1}
4 存储数据 http://192.168.1.201:9100/commitUserData?
    {"cmd":"commitUserData", "appid":1}

-- 目前支持的http请求
1 register
2 login
3 modifyPassword
4 commitUserData
--]]

local function handle_Register()
    local appid = req.appid
    local platform = tonumber(req.platform)
    local username = req.account
    local password = req.password
    local email = req.email or ""
    local phone = req.phone or ""

    -- 账号不能为空
    if not password or password == "" or not username or username == "" then
        WARN("NULL username or password")
        return {
            status      = E.eRegisterRespStatus.RS_NULL_FAIlED,
            errorMsg    = "account is empty",
        }
    end

    -- 账号已经存在
    local p = redisx.hgettable(account_redis_key, platform_account)
    if p then
        WARN("User exist", p,p.account)
        return {
            status      = E.eRegisterRespStatus.RS_EXIST_FAILED,
            errorMsg    = "accout had exist",
        }
    end

    -- 注册
    local accountInfo = {
        account     = username,
        password    = password,
        platform    = platform,
    }

    -- write 2 db
    redisx.hsettable(account_redis_key, platform_account, accountInfo)

    return {
        status      = ErrorCode.success[1],
        errorMsg    = ErrorCode.success[2],
    }
end

local function handle_Login()

end

local function handle_ModifyPassword()

end

local function handle_CommitUserData()

end

local http_req_tb = {
    ["register"]        = handle_Register,
    ["login"]           = handle_Login,
    ["modifyPassword"]  = handle_ModifyPassword,
    ["commitUserData"]  = handle_CommitUserData,
}

skynet.start(function()
    accountservice = skynet.localname(".accountservice")

    skynet.dispatch("lua", function (_, _, id, addr)
        socket.start(id)
        -- limit request body size to 8192 (you can pass nil to unlimit)
        local code, url, method, header, body = httpd.read_request(sockethelper.readfunc(id), 8192)
        DEBUG("request data:", code, url)
        if code then
            if code ~= 200 then  -- 如果协议解析有问题，就回应一个错误码 code 。
                response(id, code)
            else
                -- 这是一个示范的回应过程，你可以根据你的实际需要解析 url, method 和 header 做出回应。
                local tmp = {}
                local path, query = urllib.parse(url)
                local ismatch = false
                for cmd, func in pairs(http_req_tb) do
                    if string.match(path, cmd) then -- 只要找到就算数
                        ismatch = true
                        local req = urllib.parse_query(query)
                        local resp = func(req, addr)
                        response(id, code, json.encode(resp))
                        break
                    end
                end

                if not ismatch then
                    response(id, 404) -- 未知请求
                end
            end
        else
            if url == sockethelper.socket_error then
                skynet.error("socket closed")
            else
                skynet.error(url)
            end
        end
        socket.close(id)
    end)
end)

else

skynet.start(function()
    local agent = {}
    for i= 1, settings.account_conf.account_web_slave_count do
        agent[i] = skynet.newservice(SERVICE_NAME, "agent")
    end

    local balance = 1
    local id = socket.listen("0.0.0.0", settings.account_conf.account_web_port)
    socket.start(id , function(id, addr)
        INFO(string.format("%s connected, pass it to agent :%08x", addr, agent[balance]))
        skynet.send(agent[balance], "lua", id, addr)
        balance = balance + 1
        if balance > #agent then
            balance = 1
        end
    end)
end)

end
