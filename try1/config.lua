-- 一个配置文件只有一个服务器，监听一个端口
-- 但可以有多个host，每个host，有自己的log文件
-- 文件的最深table结构有4层
-- 全局变量4种类型，数字，字符串，hash, array
-- array 中，每个元素中含有若干string, string对
-- array 每个元素中，可以包含一层的hash<string, string>结构体


--------------------- 预定义变量区 --------------------
static_lgcms = { type="dir", removeprefix='/media' }

static_default = { type="dir" }

handler_lgcms = { type="handler", 
		send_addr ='tcp://127.0.0.1:1234',
		recv_addr ='tcp://127.0.0.1:1235', 
}

zmqport = '12310'


----------- start ------------
name = "server1"
bind_addr = "0.0.0.0"
port = 8080

default_host = "mechat"

hosts = { 
    {       
        name = "mechat",
        --matching="lgcms",
        access_log = "access_mechat",
        error_log = "error_mechat",
        root_dir = "/home/mike/workspace/mobilechat/manage/media/",

        routes = {
            ['/'] = "handler_lgcms",
            ['/media/'] = "static_lgcms",
        }
    },

    {       
        name = "lgcms",
        --matching="lgcms",
        access_log = "access_lgcms",
        error_log = "error_lgcms",
        root_dir = "/home/mike/workspace/lgcms/media/",

        routes = {
            ['/'] = "handler_lgcms",
            ['/media/'] = "static_lgcms",
        }
    },
    
    


}

