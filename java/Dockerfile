# 设置基础镜像
FROM openjdk:11-jdk

# 设置工作目录
WORKDIR /app

# 复制项目文件
COPY pom.xml /app

# 检查 Maven 是否已安装
RUN command -v mvn >/dev/null 2>&1 || { \
    echo "Maven not found, installing..."; \
    apt-get update && apt-get install -y maven; \
}

# 修改maven源
RUN sed -i 's/<mirrors>/<mirrors>\n<mirror>\n<id>aliyun<\/id>\n<name>Aliyun Maven<\/name>\n<url>https:\/\/maven.aliyun.com\/repository\/central<\/url>\n<mirrorOf>central<\/mirrorOf>\n<\/mirror>/g' /usr/share/maven/conf/settings.xml

# 仅当 pom.xml 发生变化时才执行 Maven 的 install 步骤
RUN mvn dependency:go-offline -B

COPY . /app

RUN mvn install -DskipTests

# 启动命令
CMD ["java", "-jar", "/app/target/novel_crawler-1.0.0-SNAPSHOT.jar", "--spring.profiles.active=prod"]
