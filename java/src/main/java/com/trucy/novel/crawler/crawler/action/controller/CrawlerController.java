package com.trucy.novel.crawler.crawler.action.controller;

import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@Tag(name = "爬虫")
@CrossOrigin(origins = "*")
@RequestMapping("/crawler")
public class CrawlerController {
}
