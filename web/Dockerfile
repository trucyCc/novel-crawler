# 设置基础镜像
FROM node:16.17.1

# 设置工作目录
WORKDIR /app

# 安装依赖
COPY package.json package-lock.json /app/
RUN npm install

# 复制项目文件
COPY . /app/

# 添加root权限
USER root

# 启动命令
CMD ["npm", "run", "dev"]
