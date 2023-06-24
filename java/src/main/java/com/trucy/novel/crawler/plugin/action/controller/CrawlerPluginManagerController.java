package com.trucy.novel.crawler.plugin.action.controller;

import com.trucy.novel.crawler.plugin.action.service.CrawlerPluginManagerService;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Map;

@Slf4j
@Tag(name = "爬虫插件")
@RestController
@AllArgsConstructor
@CrossOrigin(origins = "*")
@RequestMapping("/plugin")
public class CrawlerPluginManagerController {
    private CrawlerPluginManagerService crawlerPluginManagerService;

    /**
     * 加载配置目录下的插件
     */
    @GetMapping("/load")
    public Map<String, String> loadPlugin() {
        return crawlerPluginManagerService.loadPlugin();
    }

    /**
     * 获取当前可用的源
     */
    @GetMapping("/sources")
    public Map<String, Object> getSources() {
        return crawlerPluginManagerService.getPluginNames();
    }
}
