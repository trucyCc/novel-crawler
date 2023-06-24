package com.trucy.novel.crawler.exception;

import lombok.Data;

@Data
public class CrawlerException extends RuntimeException {
    private String errorMessage;
    private Throwable t;

    public CrawlerException() {
    }

    public CrawlerException(String errorMessage) {
        super(errorMessage);
        this.errorMessage = errorMessage;
    }

    public CrawlerException(String errorMessage, Throwable t) {
        super(errorMessage, t);
        this.errorMessage = errorMessage;
        this.t = t;
    }
}
