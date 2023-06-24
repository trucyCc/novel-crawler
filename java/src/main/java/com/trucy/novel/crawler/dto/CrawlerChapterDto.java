package com.trucy.novel.crawler.dto;

import lombok.*;

@Data
@Builder
@ToString
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
public class CrawlerChapterDto {
    private String id;
    private String url;
    private String name;
    private String htmlContent;
}
