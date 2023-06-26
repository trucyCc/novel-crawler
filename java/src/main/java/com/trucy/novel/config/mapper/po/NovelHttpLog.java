package com.trucy.novel.config.mapper.po;

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
@Table(name = "novel_http_log")
public class NovelHttpLog {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "http_log_id", nullable = false)
    private Integer id;

    @Column(name = "http_method", nullable = false, length = 20)
    private String httpMethod;

    @Column(name = "url", nullable = false, length = 100)
    private String url;

    @Column(name = "request_ip", length = 20)
    private String requestIp;

    @Column(name = "request_params", length = 500)
    private String requestParams;

    @Column(name = "response_status", length = 20)
    private String responseStatus;

    @Lob
    @Column(name = "response_body")
    private String responseBody;

    @Column(name = "created_at")
    private Instant createdAt;

    @Column(name = "updated_at")
    private Instant updatedAt;
}