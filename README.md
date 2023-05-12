## java-spring-jpa-template
java springboot template with jpa, satoken

## 注意事项
启动项目前，需要对项目内需要被标注的初始化的TODO注释下的内容进行修改

## 目录结构

├─config	配置项  
│  ├─request	响应配置项  
│  │  └─ex	自定义异常  
│  └─swagger	Swagger配置项  
├─scheduled	定时服务  
│  ├─job	定时任务  
│  └─utils	定时所需的工具  
├─template	服务（应该将整体项目拆分成多个业务项）  
│  ├─dao	数据层  
│  │  ├─entity	数据实体类  
│  │  └─repo	数据服务类  
│  ├─domain  
│  │  ├─service	当业务复杂时应该将Sevice拆分成多个  
│  │  ├─controller	  
│  │  └─dto	数据传输对象  
│  │  └─vo 数据展示对象  
│  └─em 枚举类
│  └─utils 只有当前服务才会使用的工具  
└─utils 通用工具  


├─application.yml		主配置文件，设置启动时用哪个配置文件  
├─application-dev.yml	测试配置  
├─application-local.yml	本地配置  
└─application-prod.yml	生产配置