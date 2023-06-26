package com.trucy.novel.auth.config.exception;


import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class AdminAuthException extends RuntimeException{
    private String message;
    private Throwable throwable;

    public AdminAuthException() {
    }

    public AdminAuthException(String message) {
        super(message);
        this.message = message;
    }

    public AdminAuthException(String message, Throwable t) {
        super(message, t);
        this.message = message;
        this.throwable = t;
    }
}
