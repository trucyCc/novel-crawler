package com.trucy.java.config.request;

import lombok.extern.slf4j.Slf4j;
import org.springframework.core.MethodParameter;
import org.springframework.http.MediaType;
import org.springframework.http.converter.HttpMessageConverter;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.servlet.mvc.method.annotation.ResponseBodyAdvice;

/**
 * 全局响应数据处理
 */
@Slf4j
@ControllerAdvice
public class CustomResponseBodyAdvice implements ResponseBodyAdvice<Object> {

    @Override
    public boolean supports(MethodParameter returnType, Class<? extends HttpMessageConverter<?>> converterType) {
        // 在这里可以对指定的Controller方法返回类型进行判断，是否需要处理
        return true; // 例如，对所有的Controller方法返回类型进行处理
    }

    /**
     * 在这里可以对响应进行修改或增强
     */
    @Override
    public Object beforeBodyWrite(Object body, MethodParameter returnType, MediaType selectedContentType, Class<? extends HttpMessageConverter<?>> selectedConverterType, ServerHttpRequest request, ServerHttpResponse response) {
        // 不对swagger的返回数据进行处理
        if (request.getURI().getPath().contains("swagger") ||
                request.getURI().getPath().contains("api-docs")) {
            return body;
        }

        // 全局异常捕捉处理后已经组装好数据，可以直接返回消费者
        if (body instanceof ApiResponse) {
            return body;
        }

        // uri路径包含error的报错数据
        if (request.getURI().getPath().contains("error")) {
            log.error("error: {}", body);
        }

        // 组装数据
        return ApiResponse.builder().code(200).message("成功").data(body).build();
    }
}
