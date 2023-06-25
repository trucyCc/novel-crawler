package com.trucy.novel.crawler.plugin.loader;

import cn.hutool.core.util.StrUtil;
import com.trucy.novel.crawler.base.CrawlerParse;
import com.trucy.novel.crawler.exception.CrawlerPluginException;
import com.trucy.novel.crawler.plugin.config.CrawlerPluginConfig;
import lombok.AllArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import org.apache.commons.collections4.CollectionUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;

import java.io.File;
import java.io.IOException;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLClassLoader;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Objects;
import java.util.concurrent.ConcurrentHashMap;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.stream.Collectors;

@Slf4j
@Component
@AllArgsConstructor
public class CrawlerPluginLoader {
    private CrawlerPluginConfig crawlerPluginConfig;

    // 插件实例化存储
    public static ConcurrentHashMap<String, CrawlerParse> pluginMap = new ConcurrentHashMap<>();

    /**
     * 加载目录内的插件
     */
    public synchronized void loadPlugin() throws CrawlerPluginException {
        ConcurrentHashMap<String, CrawlerParse> tempPluginMap = new ConcurrentHashMap<>();

        // 加载插件目录
        val pluginDir = new File(crawlerPluginConfig.getPluginDir());

        // 获取插件目录下所有的.jar文件
        val pluginFiles = pluginDir.listFiles((dir, name) -> name.endsWith(".jar"));

        if (pluginFiles == null || pluginFiles.length == 0) {
            log.error("插件目录为空！插件目录：{}", pluginDir);
            throw new CrawlerPluginException(StrUtil.format("插件目录为空！插件目录：{}", pluginDir));
        }

        // 将插件文件的URL添加到数组当中
        val pluginUrls = Arrays.stream(pluginFiles).map(file -> {
            val fileUri = file.toURI();
            try {
                return fileUri.toURL();
            } catch (MalformedURLException e) {
                log.error("插件Uri转Url失败！fileUri:{}", fileUri, e);
                return null;
            }
        }).filter(Objects::nonNull).collect(Collectors.toList());

        if (CollectionUtils.isEmpty(pluginUrls)) {
            log.error("插件Url为空！插件目录：{}, 文件名：{}", pluginDir,
                    Arrays.stream(pluginFiles)
                            .map(File::getName)
                            .collect(Collectors.toList()));
            throw new CrawlerPluginException(
                    StrUtil.format("插件Url为空！插件目录：{}, 文件名：{}",
                            pluginDir,
                            Arrays.stream(pluginFiles)
                                    .map(File::getName)
                                    .collect(Collectors.toList())));
        }

        // 创建一个URLClassLoader，用于加载插件
        val classLoader = new URLClassLoader(pluginUrls.toArray(new URL[0]));

        // 加载插件到内存当中
        for (File pluginFile : pluginFiles) {
            val pluginClassName = getPluginClassName(pluginFile, classLoader);
            if (StringUtils.isBlank(pluginClassName)) {
                log.error("该jar包中没有匹配的Class！jarName:{}", pluginFile.getName());
                continue;
            }

            try {
                // 加载类
                Class<?> pluginClass = classLoader.loadClass(pluginClassName);

                // 创建实例
                Constructor<?> constructor = pluginClass.getDeclaredConstructor();
                constructor.setAccessible(true);
                Object pluginInstance = constructor.newInstance();

                if (pluginInstance instanceof CrawlerParse) {
                    CrawlerParse crawlerParse = (CrawlerParse) pluginInstance;

                    // 插件名为空或者插件名已经存在
                    if (StringUtils.isBlank(crawlerParse.getPluginName()) ||
                            tempPluginMap.containsKey(crawlerParse.getPluginName())) {
                        log.error("插件名已存在！请修改插件名后重新加载！");
                        continue;
                    }

                    // 压入内存当中
                    tempPluginMap.put(crawlerParse.getPluginName(), crawlerParse);
                }

                // 关闭类加载器
                try {
                    classLoader.close();
                } catch (IOException e) {
                    throw new CrawlerPluginException("加载插件异常！类加载器无法关闭！", e);
                }

            } catch (ClassNotFoundException e) {
                log.error("插件加载失败，没有找到类！pluginClassName:{}", pluginClassName, e);
            } catch (NoSuchMethodException e) {
                log.error("插件加载失败，没有找到构造方法！pluginClassName:{}", pluginClassName, e);
            } catch (InvocationTargetException | InstantiationException | IllegalAccessException e) {
                log.error("插件加载失败，实例化失败！pluginClassName:{}", pluginClassName, e);
            }
        }

        pluginMap.clear();;
        pluginMap.putAll(tempPluginMap);
        tempPluginMap.clear();
    }

    private static String getPluginClassName(File pluginFile, ClassLoader classLoader) {
        // 读取jar文件
        try (JarFile jarFile = new JarFile(pluginFile)) {
            Enumeration<JarEntry> entries = jarFile.entries();
            while (entries.hasMoreElements()) {
                JarEntry entry = entries.nextElement();
                String className = entry.getName().replace('/', '.');

                // 在指定包路径下查询
                if (className.startsWith("com.trucy.novel.crawler.plugin") && className.endsWith(".class")) {
                    // 格式化类名
                    className = className.substring(0, className.length() - ".class".length());
                    try {
                        log.info("类名:{}", className);

                        // 加载类
                        Class<?> cls = classLoader.loadClass(className);

                        // 判断是否是CrawlerParse的实现类
                        if (cls.getName().endsWith("ParsePlugin")) {
                            return className;
                        }

                    } catch (ClassNotFoundException e) {
                        log.error("无法加载类！className: {}", className, e);
                    }
                }
            }
        } catch (IOException e) {
            log.error("无法读取插件文件！pluginFile: {}", pluginFile, e);
        }
        return null;
    }

    public static Boolean checkPluginByName(String name) {
        return pluginMap.containsKey(name);
    }
}
