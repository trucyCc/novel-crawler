package com.trucy.novel.crawler.dto;

import com.trucy.novel.crawler.em.BookSerialStatus;
import lombok.*;

import java.util.List;

@Data
@Builder
@ToString
@EqualsAndHashCode
@AllArgsConstructor
@NoArgsConstructor
public class CrawlerBookDto {
    private String name;
    private String author;
    private String url;
    private BookSerialStatus status;
    private String coverUrl;
    private String intro;
    private List<CrawlerChapterDto> chapters;
    private String lastUpdateTime;
}
