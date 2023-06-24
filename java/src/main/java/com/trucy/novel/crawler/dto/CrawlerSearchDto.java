package com.trucy.novel.crawler.dto;

import lombok.*;

@Data
@Builder
@ToString
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
public class CrawlerSearchDto {
    private String id;
    private String name;
    private String author;
    private String url;
    private String status;
    private String lastChapterName;
    private String lastChapterUrl;
    private String lastUpdateTime;
    private String wordCount;

}
