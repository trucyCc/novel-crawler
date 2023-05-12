package com.trucy.java.config.swagger;

import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import io.swagger.v3.oas.models.media.StringSchema;
import io.swagger.v3.oas.models.parameters.Parameter;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springdoc.core.GroupedOpenApi;
import org.springdoc.core.SpringDocConfiguration;
import org.springframework.boot.autoconfigure.AutoConfigureBefore;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@AutoConfigureBefore(SpringDocConfiguration.class)
public class OpenApiConfig {

    private static final String TOKEN_HEADER = "Authorization";

    @Bean
    public OpenAPI openApi() {
        return new OpenAPI()
                .components(
                        new Components().addSecuritySchemes(TOKEN_HEADER,
                                new SecurityScheme()
                                        .type(SecurityScheme.Type.APIKEY)
                                        // 这里配置 bearer 后，你的请求里会自动在 token 前加上 Bearer
                                        .scheme("bearer")
                                        .bearerFormat("JWT")
                        ).addParameters(TOKEN_HEADER,
                                new Parameter()
                                        .in("header")
                                        .schema(new StringSchema())
                                        .name("Authorization")
                        ))
                .info(
                        // todo: 初始化-需要修改Swagger的信息
                        new Info()
                                .title("Java Spring Jpa Template")
                                .description("java springboot with jpa template")
                                .version("0.1")
                );
    }

    /**
     * GroupedOpenApi 是对接口文档分组，类似于 swagger 的 Docket
     */
    @Bean
    public GroupedOpenApi templateApi() {
        // todo：初始化-需要重新生成OpenApi配置
        return GroupedOpenApi.builder()
                // 组名
                .group("Group Name")
                // 扫描的包
                .packagesToScan("com.trucy.java")
                .build();
    }
}