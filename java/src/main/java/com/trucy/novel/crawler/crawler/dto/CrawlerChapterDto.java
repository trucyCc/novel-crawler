package com.trucy.novel.crawler.crawler.dto;

import lombok.*;

@Data
@Builder
@ToString
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
public class CrawlerChapterDto {
    private String url;
    private String name;
    private String htmlContent;
}
