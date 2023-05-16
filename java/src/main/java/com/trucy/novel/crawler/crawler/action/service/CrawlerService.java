package com.trucy.novel.crawler.crawler.action.service;

import com.trucy.novel.crawler.crawler.dto.CrawlerBookDto;
import com.trucy.novel.crawler.crawler.dto.CrawlerChapterDto;
import com.trucy.novel.crawler.crawler.dto.CrawlerSearchDto;
import com.trucy.novel.crawler.crawler.plugin.Crawler1ParsePlugin;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.ArrayList;

@Slf4j
@Service
@AllArgsConstructor
public class CrawlerService {
    private final Crawler1ParsePlugin crawler1ParsePlugin;

    public ArrayList<CrawlerSearchDto> search(String name) {
        return crawler1ParsePlugin.query(name);
    }

    public CrawlerBookDto getBookInfo(String url) {
        return crawler1ParsePlugin.crawlerBook(url);
    }

    public CrawlerChapterDto getChapter(String url) {
        return crawler1ParsePlugin.crawlerChapter(url);
    }


}
