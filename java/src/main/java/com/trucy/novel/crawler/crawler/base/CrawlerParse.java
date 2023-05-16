package com.trucy.novel.crawler.crawler.base;


import com.trucy.novel.crawler.crawler.dto.CrawlerBookDto;
import com.trucy.novel.crawler.crawler.dto.CrawlerChapterDto;
import com.trucy.novel.crawler.crawler.dto.CrawlerSearchDto;

import java.util.ArrayList;

/**
 * 通过Valid获取验证书籍名称，对插件内方法进行验证是否有效
 * 获取书名并无法查询出相关结果的插件将无法加载
 */
public abstract class CrawlerParse {
    /**
     * 根据书名或作者名称进行搜索
     *
     * @param name 书名/作者名
     * @return 搜索结果
     */
    public abstract ArrayList<CrawlerSearchDto> query(String name);

    /**
     * 获取可以验证插件的书籍名称
     *
     * @return 验证插件状态
     */
    public abstract String getBookNameValidPlugin();

    /**
     * 根据Url爬取相对应的书籍
     *
     * @param url 要爬取书籍的url
     * @return 书籍信息
     */
    public abstract CrawlerBookDto crawlerBook(String url);

    /**
     * 根据Url爬取相对应的章节
     *
     * @param url 要爬取章节的url
     * @return 章节信息
     */
    public abstract CrawlerChapterDto crawlerChapter(String url);
}
