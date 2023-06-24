package com.trucy.novel.crawler.em;

import lombok.AllArgsConstructor;
import lombok.Getter;

@Getter
@AllArgsConstructor
public enum BookSerialStatus {
    SERIAL(0, "连载中"),
    FINISH(1, "已完结"),
    UNKNOWN(2, "未知");

    private Integer code;
    private String desc;

    public static BookSerialStatus toValue(String text)  {
        for (BookSerialStatus status : BookSerialStatus.values()) {
            if (text.contains("载") || text.contains("新")) {
                return SERIAL;
            }

            if (text.contains("完")) {
                return FINISH;
            }
        }

        return UNKNOWN;
    }
}
