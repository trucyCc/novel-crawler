package com.trucy.novel.crawler.action.service;

import com.trucy.novel.crawler.action.nanotation.ValidCrawlerPluginName;
import com.trucy.novel.crawler.dto.CrawlerBookDto;
import com.trucy.novel.crawler.dto.CrawlerChapterDto;
import com.trucy.novel.crawler.dto.CrawlerSearchDto;
import com.trucy.novel.crawler.plugin.context.CrawlerPluginContext;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Slf4j
@Service
@AllArgsConstructor
public class CrawlerService {
    private CrawlerPluginContext crawlerPluginContext;

    @ValidCrawlerPluginName
    public ArrayList<CrawlerSearchDto> search(String source, String name) {
        crawlerPluginContext.instanceInstance(source);
        return crawlerPluginContext.executeQuery(name);
    }

    @ValidCrawlerPluginName
    public CrawlerBookDto getBookInfo(String source, String url) {
        crawlerPluginContext.instanceInstance(source);
        return crawlerPluginContext.executeCrawlerBook(url);
    }

    @ValidCrawlerPluginName
    public CrawlerChapterDto getChapter(String source, String url) {
        crawlerPluginContext.instanceInstance(source);
        return crawlerPluginContext.executeCrawlerChapter(url);
    }


}
