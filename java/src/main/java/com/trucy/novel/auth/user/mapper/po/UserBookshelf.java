package com.trucy.novel.auth.user.mapper.po;

import lombok.*;

import javax.persistence.*;
import java.time.Instant;

@Builder
@AllArgsConstructor
@NoArgsConstructor
@Getter
@Setter
@ToString
@Entity
@Table(name = "user_bookshelf")
public class UserBookshelf {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "user_bookshelf_id", nullable = false)
    private Integer id;

    @ToString.Exclude
    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "user_id", nullable = false)
    private NovelUser user;

    @Column(name = "book_source", nullable = false, length = 100)
    private String bookSource;

    @Column(name = "last_chapter_url", nullable = false, length = 500)
    private String lastChapterUrl;

    @Column(name = "last_chapter_name", nullable = false, length = 200)
    private String lastChapterName;

    @Column(name = "book_cover_url", length = 1000)
    private String bookCoverUrl;

    @Column(name = "created_at")
    private Instant createdAt;

    @Column(name = "updated_at")
    private Instant updatedAt;
}