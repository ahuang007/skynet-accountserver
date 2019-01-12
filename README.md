# skynet-loginserver

* 用skynet做登录服务 
* 目标：
  - 作一个通用的登录服务
  - 支持http请求+json数据
  - 存储用redis
* 缺陷： 
  - 暂不考虑过频请求以及攻击
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
      {"cmd":"register", "appid":1, "data":{"account":"test001", "password":"123456"}} 
    ```
    - 参数说明：
    ```
      cmd:请求命令类型
      appid：游戏id(需要前后台约定好 比如 1：2048 2：flappy bird)
      data:请求参数(json数据）
        account :账号
        password:密码
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
      {"status":0, errorMsg:"ok"}
    ```
    - 参数说明：
    ```
      status: 返回值 0 表示正常 其他值则不正常 待定
      errorMsg: 错误消息
    ```
    
    3. 修改密码（需要先登录 需要session）
    - 请求数据示例：(新密码需要前端2次确认)
    ```
      {"cmd":"modifyPassword", "appid":1, "data":{"oldPassword":"123456", "newPassword":"111111"}}
    ```
    - 参数说明：
    ```
      cmd:请求命令类型
      appid：游戏类型(需要前后台约定好 比如 1：2048 2：flappy bird)
      data:请求参数(json数据）
        oldPassword :旧密码
        newPassword :新密码
    ```
  - 返回数据示例:
    ```
      {"status":0, errorMsg:"ok"}
    ```
    
