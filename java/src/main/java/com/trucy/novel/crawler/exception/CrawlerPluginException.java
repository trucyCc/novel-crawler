package com.trucy.novel.crawler.exception;

import lombok.Data;

@Data
public class CrawlerPluginException extends RuntimeException {
    private String errorMessage;
    private Throwable t;

    public CrawlerPluginException() {
    }

    public CrawlerPluginException(String errorMessage) {
        super(errorMessage);
        this.errorMessage = errorMessage;
    }

    public CrawlerPluginException(String errorMessage, Throwable t) {
        super(errorMessage, t);
        this.errorMessage = errorMessage;
        this.t = t;
    }
}
