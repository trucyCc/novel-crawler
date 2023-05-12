package com.trucy.java.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.stereotype.Component;


// todo: 业务需要在配置文件中配置的项
@Data
@Component
@ConfigurationProperties(prefix = "config.business")
public class BusinessConfig {
    private String prefix;
}
