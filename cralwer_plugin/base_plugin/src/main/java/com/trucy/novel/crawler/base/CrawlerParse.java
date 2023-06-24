package com.trucy.novel.crawler.base;


import com.trucy.novel.crawler.dto.CrawlerBookDto;
import com.trucy.novel.crawler.dto.CrawlerChapterDto;
import com.trucy.novel.crawler.dto.CrawlerSearchDto;

import java.util.ArrayList;

/**
 * 通过Valid获取验证书籍名称，对插件内方法进行验证是否有效
 * 获取书名并无法查询出相关结果的插件将无法加载
 */
public interface CrawlerParse {
    /**
     * 根据书名或作者名称进行搜索
     *
     * @param name 书名/作者名
     * @return 搜索结果
     */
    ArrayList<CrawlerSearchDto> query(String name);

    /**
     * 获取验证插件
     *
     * @return 验证插件状态
     */
    void validPlugin();

    /**
     * 根据Url爬取相对应的书籍
     *
     * @param url 要爬取书籍的url
     * @return 书籍信息
     */
    CrawlerBookDto crawlerBook(String url);

    /**
     * 根据Url爬取相对应的章节
     *
     * @param url 要爬取章节的url
     * @return 章节信息
     */
    CrawlerChapterDto crawlerChapter(String url);


    /**
     * 获取Plugin名称，用于查询时匹配目标源
     * 不可以重复，不可以为空
     *
     * @return 插件名
     */
    String getPluginName();
}
