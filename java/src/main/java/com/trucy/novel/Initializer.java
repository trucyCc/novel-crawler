package com.trucy.novel;

import com.trucy.novel.crawler.plugin.loader.CrawlerPluginLoader;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import org.springframework.stereotype.Component;

import javax.annotation.PostConstruct;
import java.util.HashMap;

@Slf4j
@Component
@AllArgsConstructor
public class Initializer {
    private CrawlerPluginLoader crawlerPluginLoader;

    @PostConstruct
    public void init() {
        crawlerPluginLoader.loadPlugin();

        val pluginCount = CrawlerPluginLoader.pluginMap.size();
        val sourceName = CrawlerPluginLoader.pluginMap.keySet().toArray(new String[0]);
        val resultMap = new HashMap<String, String>();
        log.info("已加载插件数量：{}, 已加载插件源名称：{}", pluginCount, sourceName);
    }
}
