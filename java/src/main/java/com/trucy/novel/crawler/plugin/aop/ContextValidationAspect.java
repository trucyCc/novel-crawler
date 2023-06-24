package com.trucy.novel.crawler.plugin.aop;

import cn.hutool.core.util.StrUtil;
import com.trucy.novel.crawler.exception.CrawlerPluginException;
import com.trucy.novel.crawler.base.CrawlerParse;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.springframework.stereotype.Component;

import java.lang.reflect.Field;

@Slf4j
@Aspect
@Component
public class ContextValidationAspect {
    @Before("@annotation(com.trucy.novel.crawler.plugin.nanotation.ContextValidCrawlerParse)")
    public void beforeMethodValidCrawlerParseExecution(JoinPoint joinPoint) throws CrawlerPluginException {
        Object target = joinPoint.getTarget();  // 获取目标类对象
        String crawlerParseFieldName = "crawlerParse";
        try {
            Field crawlerParseField = target.getClass().getDeclaredField(crawlerParseFieldName);
            crawlerParseField.setAccessible(true);
            CrawlerParse crawlerParse = (CrawlerParse) crawlerParseField.get(target);
            if (crawlerParse == null) {
                throw new CrawlerPluginException("请先加载解析插件！");
            }
        } catch (NoSuchFieldException e) {
            log.error("没有找到指定成员对象！成员对象名称:{}", crawlerParseFieldName);
            throw new CrawlerPluginException(StrUtil.format("没有找到指定成员对象！成员对象名称:{}", crawlerParseFieldName));
        } catch (IllegalAccessException e) {
            log.error("从目标类获取成员对象失败！目标类路径：{} 成员对象名称:{}", target.getClass().getName(), crawlerParseFieldName);
            throw new CrawlerPluginException(StrUtil.format("从目标类获取成员对象失败！目标类路径：{} 成员对象名称:{}", target.getClass().getName(), crawlerParseFieldName));
        }

    }
}
