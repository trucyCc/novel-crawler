package com.trucy.novel.crawler.action.aop;

import cn.hutool.core.util.StrUtil;
import com.trucy.novel.crawler.exception.CrawlerException;
import com.trucy.novel.crawler.exception.CrawlerPluginException;
import com.trucy.novel.crawler.plugin.loader.CrawlerPluginLoader;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

@Slf4j
@Aspect
@Component
public class ValidCrawlerPluginAspect {
    @Before("@annotation(com.trucy.novel.crawler.action.nanotation.ValidCrawlerPluginName)")
    public void beforeValidCrawlerPluginExecution(JoinPoint joinPoint) throws CrawlerPluginException {
        Object[] args = joinPoint.getArgs();
        String source = (String) args[0];
        if (!CrawlerPluginLoader.checkPluginByName(source)) {
            throw new CrawlerException(StrUtil.format("抱歉，该目标源无效！目标源: {}", source));
        }
    }
}
