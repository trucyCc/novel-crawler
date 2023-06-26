package com.trucy.novel.auth.config.exception;

import lombok.Data;
import lombok.EqualsAndHashCode;

@Data
@EqualsAndHashCode(callSuper = true)
public class UserAuthException extends RuntimeException {
    private String message;
    private Throwable throwable;

    public UserAuthException() {
    }

    public UserAuthException(String message) {
        super(message);
        this.message = message;
    }

    public UserAuthException(String message, Throwable t) {
        super(message, t);
        this.message = message;
        this.throwable = t;
    }
}
