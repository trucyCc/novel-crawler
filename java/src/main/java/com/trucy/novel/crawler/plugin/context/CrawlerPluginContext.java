package com.trucy.novel.crawler.plugin.context;

import cn.hutool.core.util.StrUtil;
import com.trucy.novel.crawler.exception.CrawlerPluginException;
import com.trucy.novel.crawler.base.CrawlerParse;
import com.trucy.novel.crawler.dto.CrawlerBookDto;
import com.trucy.novel.crawler.dto.CrawlerChapterDto;
import com.trucy.novel.crawler.dto.CrawlerSearchDto;
import com.trucy.novel.crawler.plugin.loader.CrawlerPluginLoader;
import com.trucy.novel.crawler.plugin.nanotation.ContextValidCrawlerParse;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import org.springframework.stereotype.Component;

import java.util.ArrayList;

@Slf4j
@Component
public class CrawlerPluginContext {
    private CrawlerParse crawlerParse;

    private void setCrawlerParse(CrawlerParse parse) {
        crawlerParse = parse;
    }

    public void instanceInstance(String pluginName) throws CrawlerPluginException {
        val pluginInstance = CrawlerPluginLoader.pluginMap.get(pluginName);
        if (pluginInstance == null) {
            log.info("没有找到指定插件! pluginName:{}", pluginName);
        }
        setCrawlerParse(pluginInstance);
    }

    @ContextValidCrawlerParse
    public ArrayList<CrawlerSearchDto> executeQuery(String name) {
        return crawlerParse.query(name);
    }

    @ContextValidCrawlerParse
    public CrawlerBookDto executeCrawlerBook(String url) {
        return crawlerParse.crawlerBook(url);
    }

    @ContextValidCrawlerParse
    public CrawlerChapterDto executeCrawlerChapter(String url) {
        return crawlerParse.crawlerChapter(url);
    }
}
