package com.trucy.novel.crawler.config.request.ex;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class BusinessException extends Exception {
    private int errorCode;
    private String errorMessage;
}
