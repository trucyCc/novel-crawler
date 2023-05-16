package com.trucy.novel.crawler.crawler.action.controller;

import com.trucy.novel.crawler.crawler.action.service.CrawlerService;
import com.trucy.novel.crawler.crawler.dto.CrawlerSearchDto;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import java.util.ArrayList;

@Slf4j
@RestController
@Tag(name = "爬虫")
@AllArgsConstructor
@CrossOrigin(origins = "*")
@RequestMapping("/crawler")
public class CrawlerController {
    private final CrawlerService crawlerService;

    @GetMapping("/query")
    public ArrayList<CrawlerSearchDto> query(@RequestParam("name") String name) {
        return crawlerService.search(name);
    }

    @PostMapping("/book")
    public Object book(@RequestParam("url") String url) {
        return crawlerService.getBookInfo(url);
    }

    @PostMapping("/chapter")
    public Object chapter(@RequestParam("url") String url) {
        return crawlerService.getChapter(url);
    }
}
