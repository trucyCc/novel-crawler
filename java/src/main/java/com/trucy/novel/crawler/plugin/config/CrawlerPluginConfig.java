package com.trucy.novel.crawler.plugin.config;

import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.context.annotation.Configuration;

@Data
@Configuration
@ConfigurationProperties("crawler")
public class CrawlerPluginConfig {
    private String pluginDir;
}
