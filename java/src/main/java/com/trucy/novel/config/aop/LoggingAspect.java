package com.trucy.novel.config.aop;

import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;

@Slf4j
@Aspect
@Component
public class LoggingAspect {

    @Pointcut("execution(* com.trucy.novel.crawler.action.controller..*.*(..)) || execution(* com.trucy.novel.crawler.plugin.action.controller..*.*(..))")
    public void controllerPointCut() {
    }

    @Before("controllerPointCut()")
    public void logRequest(JoinPoint joinPoint) {
        log.info("===============================新请求=============================");
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        String methodName = joinPoint.getSignature().getName();
        Object[] args = joinPoint.getArgs();

        // 请求ip
        String ip = request.getRemoteAddr();

        // 获取请求路径
        String url = request.getRequestURI();

        // 获取请求方法
        String method = request.getMethod();

        // 获取请求参数
        String params = Arrays.toString(args);

        log.info("Response - IP: {}", ip);
        log.info("Response - Method: {}", method);
        log.info("Response - URL: {}", url);
        log.info("Request - Method: {}", method);
        log.info("Request - Params: {}", params);
        log.info("===============================================================");
    }

    @AfterReturning(pointcut = "controllerPointCut()", returning = "result")
    public void logResponse(JoinPoint joinPoint, Object result) {
        log.info("===============================响应==============================");
        HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();
        HttpServletResponse response = ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getResponse();

        // 获取请求路径
        String url = request.getRequestURI();

        // 获取请求方法
        String method = request.getMethod();

        // 获取响应状态码
        int statusCode = 0;
        if (response != null) {
            statusCode = response.getStatus();
        }

        // 获取响应内容
        log.info("Response - Method: {}", method);
        log.info("Response - URL: {}", url);
        log.info("Response - Status Code: {}", statusCode);
        log.info("Response - Body: {}", result);
        log.info("===============================================================");
    }

}
