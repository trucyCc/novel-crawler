package com.trucy.novel.crawler.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum CrawlerPluginLoadStatus {

    NOT_LOADED(0, "未加载"),
    LOADED(1, "已加载"),
    LOAD_FAILED(2, "加载失败");

    private Integer code;
    private String desc;
}
