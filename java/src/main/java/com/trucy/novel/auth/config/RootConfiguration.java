package com.trucy.novel.auth.config;

import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;

@Configuration
@ConfigurationProperties("novel-auth")
@PropertySource("classpath:application-${spring.profiles.active}.properties")
public class RootConfiguration {
}