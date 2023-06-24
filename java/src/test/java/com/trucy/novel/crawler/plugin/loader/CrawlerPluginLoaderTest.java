package com.trucy.novel.crawler.plugin.loader;

import com.trucy.novel.crawler.plugin.config.CrawlerPluginConfig;
import lombok.extern.slf4j.Slf4j;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.boot.test.context.SpringBootTest;

import static org.mockito.Mockito.when;

@Slf4j
@SpringBootTest
class CrawlerPluginLoaderTest {
    private CrawlerPluginLoader crawlerPluginLoader;

    @Mock
    private CrawlerPluginConfig crawlerPluginConfig;

    @BeforeEach
    void setUp() {
        crawlerPluginLoader = new CrawlerPluginLoader(crawlerPluginConfig);
    }

    @Test
    void loadPlugin() {
        when(crawlerPluginConfig.getPluginDir()).thenReturn("D:\\Work\\trucy\\project\\novel-crawler\\crawler_plugin_res");

        crawlerPluginLoader.loadPlugin();

        log.info(CrawlerPluginLoader.pluginMap.toString());
    }
}