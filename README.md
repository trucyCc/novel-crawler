# novel-crawler V2.0.0
![Static Badge](https://img.shields.io/badge/dart-3.0.5-breen) ![Static Badge](https://img.shields.io/badge/flutter-3.10.5-yellow)  ![Static Badge](https://img.shields.io/badge/java-11-blue) ![Static Badge](https://img.shields.io/badge/srpingboot-2.7.11-blue) ![Static Badge](https://img.shields.io/badge/node-16.17.1-green) ![Static Badge](https://img.shields.io/badge/react-18.2.0-orange) ![Static Badge](https://img.shields.io/badge/build-docker%20compose-red)

小说爬虫，包含web和android，支持多源切换  
完成基础的功能实现，可以爬取指定网站数据，并支持检索  
完成Web端，Android端的基础实现，可以搜索书籍，查看书籍详情，查看内容实现基本的上下翻页  

**2.0服务端不支持1.0的客户端**

## V2.0 新增
1. Api添加目标源的指定
2. 添加插件管理器
3. 添加插件生成框架
4. 修改部署文件
5. Android添加书架
6. Android章节页面添加目录
7. Andorid章节页面添加章节名

## V2.0 已修复
1. Web章节上下切页是通过章节ID上下递增实现的，部分源不支持  
2. Web由于Logo部分是通过定位实现的，手机浏览器访问的时候，点击查询，Logo和查询输入框会重叠   
3. Andorid章节页没有章节名称，只有书名  
4. 上下章节切换的时候，会出现加载动画并且是在最后一页才进行加载  
5. 章节内容部分会出现底部行超过视界，导致底部行只呈现部分内容的情况  

## Server  
Server中添加了插件管理器，支持多源切换，多源检索   
新增的crawler plugin的文件夹，这个是用来生成插件的，打开后基于主模块创建一个子模块，引用base模块作为基础  
将写完的插件使用当前模板中的iar的打包插件进行打包后，放到crawler plugin re当中 程序运行时会自动读取  
插件资源目录的位置可以在配置文件中自行修改  

## Web
**首页**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/cd748e32-1fe2-4ddf-8140-72a45f3663fd)

**搜索页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/3d3cb160-956f-4bb7-9572-faeb53063f5e)

**书籍详情页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/dabf2598-a75c-4982-90f7-16d6c85e3a42)

**内容页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/4199caef-2a29-416a-ae36-24c4158ae8a9)

## Android
**首页**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/68d26614-ec9d-4642-aa73-7fcd2c4c55fd)

**搜索页面**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/389be423-df21-4c29-9ba2-6f29c783335b)

**详情**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/308649db-bc3b-4cb0-91af-7dce377af844)

**内容**  
![image](https://github.com/trucyCc/novel-crawler/assets/126760204/1b80ff43-4706-409c-9d5d-85ee276f5b2c)

**书架**  
![6c82672a1a2543227a9b434e5dc7515](https://github.com/trucyCc/novel-crawler/assets/126760204/bc108a83-624c-480f-b344-e62c9956ee77)

**内容页目录**  
![911bcff6a365f823f08267fc041c916](https://github.com/trucyCc/novel-crawler/assets/126760204/1e54d337-1653-47ce-b1df-fb429e2ab589)

### 待修复
1. 查询输入框字体位置过高  
2. 多源的情况下，无法添加相同的书到书架当中  
3. 从书架进入章节后再从章节退出，无法自动重新加载书架内容  

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
