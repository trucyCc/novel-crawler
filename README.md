# novel-crawler V1.0
小说爬虫，包含web和android，支持多源切换  
完成基础的功能实现，可以爬取指定网站数据，并支持检索  
完成Web端，Android端的基础实现，可以搜索书籍，查看书籍详情，查看内容实现基本的上下翻页  

## Server  
Server中在V1.0版本中实现了一个CrawlerPlugin插件，可以爬取对应网站的数据内容

## Web
**首页**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/cd748e32-1fe2-4ddf-8140-72a45f3663fd)

**搜索页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/3d3cb160-956f-4bb7-9572-faeb53063f5e)

**书籍详情页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/dabf2598-a75c-4982-90f7-16d6c85e3a42)

**内容页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/4199caef-2a29-416a-ae36-24c4158ae8a9)

### 待修复  
1.章节上下切页是通过章节ID上下递增实现的，部分源不支持  
2.由于Logo部分是通过定位实现的，手机浏览器访问的时候，点击查询，Logo和查询输入框会重叠    

## Android
**首页**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/68d26614-ec9d-4642-aa73-7fcd2c4c55fd)

**搜索页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/389be423-df21-4c29-9ba2-6f29c783335b)

**详情**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/308649db-bc3b-4cb0-91af-7dce377af844)

**内容**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/1b80ff43-4706-409c-9d5d-85ee276f5b2c)

### 待修复
1.查询输入框字体位置过高  
2.章节页没有章节名称，只有书名  
3.上下章节切换的时候，会出现加载动画并且是在最后一页才进行加载  
4.章节内容部分会出现底部行超过视界，导致底部行只呈现部分内容的情况  

## 部署
在服务器安装docker，docker-compose以及git  
通过git拉取项目，在项目根目录中，执行docker-compose up -build  
第一次会比较慢，要拉取maven依赖  

### 需要注意
当前默认Web是不进行构建的，只构建Server  
由于当前Web使用的是Next.js SSR的方式构建的，所以如果服务器资源比较小的情况下，请不要构建Web，否则服务器会崩掉  
服务器资源够用则可以将docker-compose.yml中的注释放开  

## 免责声明

该项目仅供学习和参考之用。使用该项目中的任何代码或文件所产生的任何结果或后果，完全由用户自行承担责任。

- 该项目的代码和文件仅供教育和学习之用，不应用于任何商业用途。
- 使用该项目中的代码或文件时，请谨慎考虑并自行承担风险。
- 作者不对该项目中的代码或文件的正确性、完整性或实用性做任何保证。
- 作者不对使用该项目中的代码或文件所产生的任何直接或间接损失或损害承担责任。
- 任何个人或实体在使用该项目中的代码或文件时，应根据自己的判断和风险承受能力进行决策。

请注意，使用该项目中的任何代码或文件即表示您同意接受上述免责声明。如果您不同意这些条件，请不要使用该项目中的任何代码或文件。
