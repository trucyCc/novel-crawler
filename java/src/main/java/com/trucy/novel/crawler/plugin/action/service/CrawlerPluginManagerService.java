package com.trucy.novel.crawler.plugin.action.service;

import cn.hutool.core.util.StrUtil;
import com.trucy.novel.crawler.plugin.loader.CrawlerPluginLoader;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import org.springframework.stereotype.Service;

import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
@AllArgsConstructor
public class CrawlerPluginManagerService {
    private CrawlerPluginLoader crawlerPluginLoader;

    public Map<String, String> loadPlugin() {
        crawlerPluginLoader.loadPlugin();

        val pluginCount = CrawlerPluginLoader.pluginMap.size();
        val sourceName = CrawlerPluginLoader.pluginMap.keySet().toArray(new String[0]);
        val resultMap = new HashMap<String, String>();
        resultMap.put("message", StrUtil.format("已加载插件数量：{}, 已加载插件源名称：{}", pluginCount, sourceName));
        return resultMap;
    }

    public Map<String, Object> getPluginNames() {
        val sourceName = CrawlerPluginLoader.pluginMap.keySet().toArray(new String[0]);
        val resultMap = new HashMap<String, Object>();
        resultMap.put("names", sourceName);
        return resultMap;
    }
}
