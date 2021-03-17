
![Go语言编程之旅：一起用Go做项目](https://upload-images.jianshu.io/upload_images/6779176-b3d6be87f88482d6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

# 1. 概述

Go语言特性请参考我的上一篇文章，本文不再赘述啦：
https://www.jianshu.com/p/2f56e491172d

本文重点介绍Go语言开发环境的安装流程，以及第一个Golang项目的开发流程（来自上面那本书）。

# 2. Go开发环境安装

### Windows10

- install git and golang in win10
  https://golangdocs.com/install-go-windows

- set envs
```
$ go env -w GO111MODULE=on
$ go env -w GOPROXY=https://goproxy.cn,direct
$ go env -w GOPATH=D:\golang
```

- IDE，推荐Jetbrains的Goland
  https://www.jetbrains.com/go/
  https://blog.jetbrains.com/go/2019/01/22/working-with-go-modules/


### Ubuntu20.04

- 下载最新版本1.16.2，并配置env
```shell
$ wget -c https://dl.google.com/go/go1.16.2.linux-amd64.tar.gz -O - | sudo tar -xz -C /usr/local
$ sed -i '$a\export PATH=$PATH:/usr/local/go/bin' ~/.profile
$ sed -i '$a\export GO111MODULE=on' ~/.profile
$ sed -i '$a\export GOPROXY=https://goproxy.cn,direct' ~/.profile
$ source ~/.profile
$ go version
go version go1.16.2 linux/amd64
```

- 参考
  https://zhuanlan.zhihu.com/p/137707249


# 3. 从零创建一个Golang项目

### 初始化项目，其中`tour`目录位置随意
```
$ mkdir tour && cd tour
$ go mod init test.com/shuzhang/tour  // will create go.mod file
$ go get -u github.com/spf13/cobra    // will create go.sum file
```

### 完善项目目录结构
```
$ touch main.go
$ mkdir -p cmd internal
$ tree tour
├── main.go
├── go.mod
├── go.sum
├── cmd
└── internal
```

### 完善代码

- 代码：[repo](https://github.com/zspishere/tour)，也可以直接clone，也可以参考[go-programming-tour-book](https://github.com/go-programming-tour-book)
- 介绍：参考[《Go 语言编程之旅：一起用 Go 做项目》](https://golang2.eddycjy.com/posts/ch1/01-simple-flag/)

### 补充说明

- 增加了makefile，汇总了一些常用的go命令

```makefile
BINARY_NAME=tour

all: test install

#compile:
#	echo "Compiling for every OS and Platform"
#	GOOS=freebsd GOARCH=386 go build -o bin/main-freebsd-386 main.go
#	GOOS=linux GOARCH=386 go build -o bin/main-linux-386 main.go
#	GOOS=windows GOARCH=386 go build -o bin/main-windows-386 main.go

build:
	go build -o ${BINARY_NAME} main.go

test:
	go test -v main.go

run: build
	./${BINARY_NAME}

install: build
	cp ./${BINARY_NAME} ${GOPATH}/bin

deps:
	go mod download

clean:
	go clean
	rm ${BINARY_NAME} ${GOPATH}/bin
```


- 增加了dockerfile，支持容器化部署

```dockerfile
FROM golang:1.16.2
LABEL maintainer="zspishere@163.com"

ENV GO111MODULE=on
ENV GOPROXY=https://goproxy.cn,direct
# ENV GOMAXPROCS=8

RUN mkdir /code
WORKDIR /code
COPY . /code/
RUN cd /code && make all

ENTRYPOINT ["tour"]
CMD ["time", "now"]
```

- 启动测试

```shell
$ docker build -t golang/tour .

$ docker run golang/tour -h
2021/03/16 15:36:11 maxprocs: Leaving GOMAXPROCS=8: CPU quota undefined
2021/03/16 15:36:11 let us begin ...
Usage:
   [command]

Available Commands:
  help        Help about any command
  json        json转换和处理
  sql         sql转换和处理
  time        时间格式处理
  word        单词格式转换

Flags:
  -h, --help   help for this command

Use " [command] --help" for more information about a command.

$ docker run golang/tour time now
2021/03/16 15:36:05 maxprocs: Leaving GOMAXPROCS=8: CPU quota undefined
2021/03/16 15:36:05 let us begin ...
2021/03/16 15:36:05 输出结果: 2021-03-16 23:36:05, 1615908965

$ docker run golang/tour json struct -s '{"a": 1, "xx": 234, "ss": {"a": 1, "xx": 234},"yy": "asdf", "listaa": ["asdf", "asdf"]}'
2021/03/17 19:42:33 maxprocs: Leaving GOMAXPROCS=8: CPU quota undefined
2021/03/17 19:42:33 let us begin ...
2021/03/17 19:42:33 输出结果:
type Tour struct {
A float64
Xx float64
Ss map[string]interface {}
Yy string
Listaa []string
}

$ docker run golang/tour sql struct --host 10.20.3.233:33306 --password 123123 --table user --username root --db test
2021/03/17 20:12:15 maxprocs: Leaving GOMAXPROCS=8: CPU quota undefined
2021/03/17 20:12:15 let us begin ...
type User struct {
         // 唯一ID
         Id     int32   `json:"id"`
         // 昵称
         Nickname       string  `json:"nickname"`
         // 姓名
         Name   string  `json:"name"`
         // 性别
         Sex    int8    `json:"sex"`
         // 部门
         Department     string  `json:"department"`
         // 生日
         Birthday       time.Time       `json:"birthday"`
         // 创建时间
         CreatedAt      time.Time       `json:"created_at"`
}
func (model User) TableName() string {
        return "user"
```

- 启动mysql服务脚本
```shell
$ docker run --name test-mysql \
     -v `pwd`/mysql:/var/lib/mysql \
     -e MYSQL_ROOT_PASSWORD=123123 \
     -p 33306:3306 \
     -d mysql
```

# 4. 下一步计划

主流的静态语言并不多，诸如C/C++、Java、C#、Go等，其中，Go凭借其自身优势，既利于项目开发迭代，又不失程序执行效率，逐渐被大厂认可。

然而，Go的坑也很多，同时语言本身也在不断升级。路漫漫其修远兮，吾将上下而求索！下一步，将继续深入学习Web、高并发等场景的应用。

补充：本文build的docker image比较大，近1G。在Production环境，可以直接使用debian镜像执行Go程序，114MB。


