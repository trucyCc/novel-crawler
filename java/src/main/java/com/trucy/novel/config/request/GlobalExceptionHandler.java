package com.trucy.novel.config.request;

import com.fasterxml.jackson.databind.exc.InvalidFormatException;
import com.trucy.novel.config.request.ex.BusinessException;
import com.trucy.novel.crawler.exception.CrawlerException;
import com.trucy.novel.crawler.exception.CrawlerPluginException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.validation.BindException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;

import javax.validation.ConstraintViolationException;
import javax.validation.ValidationException;
import java.util.ArrayList;
import java.util.List;

/**
 * 全局异常捕捉
 */
@Slf4j
@ControllerAdvice
public class GlobalExceptionHandler {

    /**
     * 捕捉自定义的业务异常
     *
     * @param ex 自定义的业务异常
     * @return 自定义返回体
     */
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(BusinessException.class)
    public ApiResponse handleBusinessException(BusinessException ex) {
        log.error("BusinessException: {}", ex.getErrorMessage(), ex);
        return ApiResponse.builder().code(ex.getErrorCode()).message(ex.getErrorMessage()).build();
    }

    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(CrawlerException.class)
    public ApiResponse handleCrawlerException(CrawlerException ex) {
        log.error("CrawlerException: {}", ex.getMessage(), ex);
        return ApiResponse.builder().code(500).message(ex.getErrorMessage()).build();
    }

    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(CrawlerPluginException.class)
    public ApiResponse handleCrawlerPluginException(CrawlerPluginException ex) {
        log.error("CrawlerPluginException: {}", ex.getMessage(), ex);
        return ApiResponse.builder().code(500).message(ex.getErrorMessage()).build();
    }


    /**
     * 捕捉注解数据验证异常（@Validation）
     *
     * @param ex 方法参数无效异常
     * @return 自定义返回体
     */
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ApiResponse handleValidationException(MethodArgumentNotValidException ex) {
        List<String> errors = new ArrayList<>();
        ex.getBindingResult().getAllErrors().forEach(error -> {
            String errorMessage = error.getDefaultMessage();
            errors.add(errorMessage);
        });
        for (String error : errors) {
            log.error("捕捉异常：MethodArgumentNotValidException ", ex);
            return ApiResponse.builder().code(500).message(error).build();
        }
        log.error("捕捉异常：MethodArgumentNotValidException ", ex);
        return ApiResponse.builder().code(500).message("未知错误").build();
    }

    /**
     * 捕捉注解数据验证异常（@Validation）
     *
     * @param ex 违反约束异常
     * @return 自定义返回体
     */
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ConstraintViolationException.class)
    public ApiResponse handleValidationException(ConstraintViolationException ex) {
        List<String> errors = new ArrayList<>();
        ex.getConstraintViolations().forEach(error -> {
            String errorMessage = error.getMessage();
            errors.add(errorMessage);
        });
        for (String error : errors) {
            log.error("捕捉异常：ConstraintViolationException ", ex);
            return ApiResponse.builder().code(500).message(error).build();
        }
        log.error("捕捉异常：ConstraintViolationException ", ex);
        return ApiResponse.builder().code(500).message("未知错误").build();
    }

    /**
     * 捕捉注解数据验证异常（@Validation）
     *
     * @param ex 校验异常
     * @return 自定义返回体
     */
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(ValidationException.class)
    public ApiResponse handleValidationException(ValidationException ex) {
        log.error("捕捉异常：ValidationException ", ex);
        return ApiResponse.builder().code(500).message(ex.getMessage()).build();
    }

    /**
     * 捕捉注解数据验证异常（@Validation）
     *
     * @param ex 无效格式异常
     * @return 自定义返回体
     */
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(InvalidFormatException.class)
    public ApiResponse handleInvalidFormatException(InvalidFormatException ex) {
        log.error("捕捉异常：InvalidFormatException ", ex);
        return ApiResponse.builder().code(500).message(ex.getMessage()).build();
    }

    /**
     * 捕捉注解数据验证异常（@Validation）
     *
     * @param ex 数据绑定异常
     * @return 自定义返回体
     */
    @ResponseBody
    @ResponseStatus(HttpStatus.BAD_REQUEST)
    @ExceptionHandler(BindException.class)
    public ApiResponse handleBindException(BindException ex) {
        List<String> errors = new ArrayList<>();
        ex.getFieldErrors().forEach(error -> {
            String errorMessage = error.getDefaultMessage();
            errors.add(errorMessage);
        });
        for (String error : errors) {
            log.error("捕捉异常：BindException ", ex);
            return ApiResponse.builder().code(500).message(error).build();
        }
        log.error("捕捉异常：BindException ", ex);
        return ApiResponse.builder().code(500).message("未知错误").build();
    }


}
