# skynet-accountserver

* 用skynet做账号服务 
* 目标：
  - 作一个通用的账号服务
  - 支持http请求+json数据
  - 存储用redis
  - 提供如下功能：
    * 注册
    * 登录
    * 修改密码
    * 提交用户数据
      * 用户数据可以的json或者其他任何格式个序列化字符串，如果不想明文可以加密
      * 限制数据的大小 预计不超过1M
      * 存储示例如下：
      ```
        account: 账号
        password：密码
        email:邮箱(可以不填,用于找回密码)
        phone:手机号(可以不填，用于找回密码)
        userdata:{
            nickname:昵称
            gender:性别
            diamond:钻石
            lastLoginTime:上次登录时间
            level：等级
            exp:经验
            activityData:{ 
              [101] = true, // 101,102为活动id
              [102] = {
                  playCount:活动已参与次数
              }
            }
            等等        
        }
        【userdata自己组织 以上仅为示例】  
      ```
* 每个游戏参数[需要申请,不同游戏之间不能影响]
  - appid: 游戏id
  - appkey: 用来加密的key
  - 加密代码如下：
  ```
  var url = "http://192.168.0.12:7211/loginserver?";			
  var obj = {"cmd":"login", "uid": 1001, "score":99};
  var str = JSON.stringify(obj); //将JSON对象转化为JSON字符
  var sign = hex_md5(str + appkey);
  url = url + "cmd=login&data=" + str + "&sign=" +sign;
  ```  
* 接口定义：
  1. 注册
  - 请求数据示例：
    ```json
      {"cmd":"register", "appid":1, "data":{"account":"test001", "password":"123456", "email":"pony@qq.com", "phone":15012345678}} 
    ```
  - 参数说明：
    ```
      cmd:请求命令类型
      appid：游戏id(需要前后台约定好 比如 1：2048 2：flappy bird)
      data:请求参数(json数据）
        account :账号
        password:密码
        email:邮箱(可以不填,用于找回密码)
        phone:手机号(可以不填，用于找回密码)
    ```
  - 返回数据示例: 
    ```
      {"status":0, "errorMsg":"ok"}
    ```
 - 参数说明：
    ```
      status: 返回值 0 表示正常 其他值则不正常 待定
      errorMsg: 错误消息
    ```
  2. 登录
 - 请求数据示例： 
    ```
      {"cmd":"login", "appid":1, "data":{"account":"test001", "password":"123456"}} 
    ```
    - 参数说明：
    ```
      cmd:请求命令类型
      appid：游戏类型(需要前后台约定好 比如 1：2048 2：flappy bird)
      data:请求参数(json数据）
        account :账号
        password:密码
    ```
  - 返回数据示例:
    ```
      {"status":0, errorMsg:"ok", "session":"xxxxxx", "userdata":"xxxxxxxx"}
    ```
    - 参数说明：
    ```
      status: 返回值 0 表示正常 其他值则不正常 待定
      errorMsg: 错误消息
      session:会话id 用于后续其他提交的合法凭证
      userdata: 用户数据
    ```
    
    3. 修改密码（需要先登录 需要传session）
    - 请求数据示例：(新密码需要前端2次确认)
    ```
      {"cmd":"modifyPassword", "appid":1, "sesion":"xxxxx" "data":{"account":"test001","oldPassword":"123456", "newPassword":"111111"}}
    ```
    - 参数说明：
    ```
      cmd:请求命令类型
      appid：游戏类型(需要前后台约定好 比如 1：2048 2：flappy bird)
      session:会话id
      data:请求参数(json数据）
        account:账号
        oldPassword :旧密码
        newPassword :新密码
    ```
  - 返回数据示例:
    ```
      {"status":0, errorMsg:"ok"}
    ```
    
    4. 提交用户数据（需要先登录 需要传session）
    - 请求数据示例：
    ```
    {"cmd":"commitUserData", "appid":1, "session":"xxxx", "data":{"account":"test001", "userdata":"xxxxxxxx"}}
    ```
     - 参数说明：
    ```
      cmd:请求命令类型
      appid：游戏类型(需要前后台约定好 比如 1：2048 2：flappy bird)
      session:会话id
      data:请求参数(json数据）
        account :账号
        userdata :用户数据
    ```
