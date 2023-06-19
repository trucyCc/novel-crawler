package com.trucy.novel.crawler.crawler.plugin;

import cn.hutool.core.collection.CollectionUtil;
import cn.hutool.core.util.StrUtil;
import com.trucy.novel.crawler.crawler.base.CrawlerParse;
import com.trucy.novel.crawler.crawler.dto.CrawlerBookDto;
import com.trucy.novel.crawler.crawler.dto.CrawlerChapterDto;
import com.trucy.novel.crawler.crawler.dto.CrawlerSearchDto;
import com.trucy.novel.crawler.crawler.em.BookSerialStatus;
import lombok.extern.slf4j.Slf4j;
import lombok.val;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.springframework.stereotype.Component;

import java.io.IOException;
import java.util.ArrayList;
import java.util.concurrent.TimeUnit;

@Slf4j
@Component
public class Crawler1ParsePlugin implements CrawlerParse {
    private static final String pluginName = "ibiquCrawlerPlugin";
    public static String url = "http://www.ibiqu.org/";
    public static String queryUrl = "http://www.ibiqu.org/modules/article/search.php?searchkey={}";

    public static void main(String[] args) {
        Crawler1ParsePlugin crawler1ParsePlugin = new Crawler1ParsePlugin();
//        ArrayList<CrawlerSearchDto> crawlerSearchList = crawler1ParsePlugin.query("斗罗大陆");
//        crawlerSearchList.forEach(c -> {
//            log.info("{}", c);
//        });

//       val data =  crawler1ParsePlugin.crawlerBook("http://www.ibiqu.org/130_130510/");
//       log.info("{}", data);


//        val cdata = crawler1ParsePlugin.crawlerChapter("http://www.ibiqu.org/130_130510/170682488.html");
//        log.info("{}", cdata);
    }

    @Override
    public ArrayList<CrawlerSearchDto> query(String name) {
        val searchList = new ArrayList<CrawlerSearchDto>();

        val client = getConnectClient();
        val request = getRequest(StrUtil.format(queryUrl, name));

        try (val response = client.newCall(request).execute()) {
            // 获取查询结果
            String responseBody = response.body().string();
            val doc = Jsoup.parse(responseBody);

            // 校验是否有查询结果
            val tbody = doc.getElementsByTag("tbody");
            if (CollectionUtil.isEmpty(tbody)) {
                log.error("[Plugin Error] 查询数据失败，无法获取标签下内容，插件失效! pluginName：{}, doc：{}", pluginName, doc);
                return searchList;
            }
            val caption = tbody.get(0);

            // 获取caption下的所有tr并进行遍历
            val trs = caption.getElementsByTag("tr");
            if (CollectionUtil.isEmpty(trs)) {
                log.error("[Plugin Error] 查询数据失败，无法获取查询列表详情，插件失效! pluginName：{}, doc：{}", pluginName, doc);
                return searchList;
            }

            for (int j = 0; j < trs.size(); j++) {
                // 过滤表头
                if (j == 0) {
                    continue;
                }

                val tr = trs.get(j);

                val crawlerSearchDto = new CrawlerSearchDto();

                val odds = tr.getElementsByClass("odd");
                if (CollectionUtil.isEmpty(odds)) {
                    log.error("[Plugin Error] 获取章节信息失败! pluginName：{}, html: {}", pluginName, tr.toString());
                    continue;
                }
                for (int i = 0; i < odds.size(); i++) {
                    val element = odds.get(i);

                    // 书名，书籍url
                    if (i == 0) {
                        crawlerSearchDto.setName(element.getElementsByTag("a").get(0).text());
                        crawlerSearchDto.setUrl(element.getElementsByTag("a").get(0).attr("href"));
                        continue;
                    }

                    // 作者名
                    if (i == 1) {
                        crawlerSearchDto.setAuthor(element.text());
                        continue;
                    }

                    // 最后更新时间
                    if (i == 2) {
                        crawlerSearchDto.setLastUpdateTime(element.text());
                    }
                }


                val evens = tr.getElementsByClass("even");
                if (CollectionUtil.isEmpty(evens)) {
                    log.error("[Plugin Error] 获取章节信息失败! pluginName：{}, html: {}", pluginName, tr.toString());
                    continue;
                }
                for (int i = 0; i < evens.size(); i++) {
                    val element = evens.get(i);


                    // 最新章节名，最新章节url
                    if (i == 0) {
                        crawlerSearchDto.setLastChapterName(element.getElementsByTag("a").get(0).text());
                        crawlerSearchDto.setLastChapterUrl(element.getElementsByTag("a").get(0).attr("href"));
                        continue;
                    }

                    // 总字数
                    if (i == 1) {
                        crawlerSearchDto.setWordCount(element.text());
                        continue;
                    }

                    // 连载状态
                    if (i == 2) {
                        crawlerSearchDto.setStatus(BookSerialStatus.toValue(element.text()));
                    }
                }

                searchList.add(crawlerSearchDto);
            }
        } catch (IOException e) {
            log.error("[Plugin Error] pluginName：{}", pluginName, e);
        }

        return searchList;
    }

    @Override
    public CrawlerBookDto crawlerBook(String url) {
        val crawlerBookDto = new CrawlerBookDto();
        val crawlerChatterDtoList = new ArrayList<CrawlerChapterDto>();

        val client = getConnectClient();
        val request = getRequest(url);

        try (val response = client.newCall(request).execute()) {
            // 获取查询结果
            String responseBody = response.body().string();
            val doc = Jsoup.parse(responseBody);

            // 信息
            val infoElement = doc.getElementById("info");
            if (infoElement == null) {
                log.error("[Plugin Error] 查询数据失败，获取书籍信息失败(info)! pluginName：{}, doc：{}", pluginName, doc);
                return crawlerBookDto;
            }

            // 书名
            val bookNameElements = infoElement.getElementsByTag("h1");
            if (CollectionUtil.isEmpty(bookNameElements)) {
                log.error("[Plugin Error] 查询数据失败，获取书籍名称失败(h1)! pluginName：{}, infoElement：{}", pluginName, infoElement);
                return crawlerBookDto;
            }
            val bookName = bookNameElements.get(0);
            if (bookName == null || StringUtils.isBlank(bookName.text())) {
                log.error("[Plugin Error] 查询数据失败，获取书籍名称失败(h1 text)! pluginName：{}, bookNameElements：{}", pluginName, bookNameElements);
                return crawlerBookDto;
            }
            crawlerBookDto.setName(bookName.text());

            // 作者
            val authorElements = infoElement.getElementsByTag("p");
            if (CollectionUtil.isEmpty(authorElements)) {
                log.error("[Plugin Error] 查询数据失败，获取书籍作者失败(p)! pluginName：{}, infoElement：{}", pluginName, infoElement);
                return crawlerBookDto;
            }
            val author = authorElements.get(0);
            if (author == null || StringUtils.isBlank(author.text())) {
                log.error("[Plugin Error] 查询数据失败，获取书籍作者失败(p text)! pluginName：{}, authorElements：{}", pluginName, authorElements);
                return crawlerBookDto;
            }
            val authorText = author.text().replace("作&nbsp;&nbsp;&nbsp;&nbsp;者：", "");
            crawlerBookDto.setAuthor(authorText);

            // 最后更新时间
            if (authorElements.size() > 3) {
                log.error("[Plugin Error] 查询数据失败，获取书籍最后更新时间失败(p size)! pluginName：{}, authorElements：{}", pluginName, authorElements);
                return crawlerBookDto;
            }
            val lastUpdateTime = authorElements.get(2);
            if (lastUpdateTime == null || StringUtils.isBlank(lastUpdateTime.text())) {
                log.error("[Plugin Error] 查询数据失败，获取书籍最后更新时间失败(time text)! pluginName：{}, authorElements：{}", pluginName, authorElements);
                return crawlerBookDto;
            }
            val lastUpdateTimeText = lastUpdateTime.text().replace("最后更新：", "");
            crawlerBookDto.setLastUpdateTime(lastUpdateTimeText);


            // 简介
            val introElement = doc.getElementById("intro");
            if (introElement == null) {
                log.error("[Plugin Error] 查询数据失败，获取书籍简介失败(intro)! pluginName：{}, doc：{}", pluginName, doc);
                return crawlerBookDto;
            }
            val intro = introElement.getElementsByTag("p");
            if (CollectionUtil.isEmpty(intro)) {
                log.error("[Plugin Error] 查询数据失败，获取书籍简介失败(p)! pluginName：{}, introElement：{}", pluginName, introElement);
                return crawlerBookDto;
            }
            val introText = intro.get(0).text();
            crawlerBookDto.setIntro(introText);

            // 封面
            val fmElement = doc.getElementById("fmimg");
            if (fmElement == null) {
                log.error("[Plugin Error] 查询数据失败，获取书籍封面失败(fmimg)! pluginName：{}, doc：{}", pluginName, doc);
                return crawlerBookDto;
            }
            val fmImgElements = fmElement.getElementsByTag("img");
            if (CollectionUtil.isEmpty(fmImgElements)) {
                log.error("[Plugin Error] 查询数据失败，获取书籍封面失败(img)! pluginName：{}, fmElement：{}", pluginName, fmElement);
                return crawlerBookDto;
            }
            val fmImg = fmImgElements.get(0);
            if (fmImg == null || StringUtils.isBlank(fmImg.attr("src"))) {
                log.error("[Plugin Error] 查询数据失败，获取书籍封面失败(src)! pluginName：{}, fmImgElements：{}", pluginName, fmImgElements);
                return crawlerBookDto;
            }
            crawlerBookDto.setCoverUrl(fmImg.attr("src"));

            // 章节
            val listElement = doc.getElementById("list");
            if (listElement == null) {
                log.error("[Plugin Error] 查询数据失败，获取书籍章节失败(list)! pluginName：{}, doc：{}", pluginName, doc);
                return crawlerBookDto;
            }
            val dlElements = listElement.getElementsByTag("dl");
            if (CollectionUtil.isEmpty(dlElements)) {
                log.error("[Plugin Error] 查询数据失败，获取书籍章节失败(dl)! pluginName：{}, listElement：{}", pluginName, listElement);
                return crawlerBookDto;
            }
            val dlElement = dlElements.get(0);
            if (dlElement == null) {
                log.error("[Plugin Error] 查询数据失败，获取书籍章节失败(dl length)! pluginName：{}, dlElements：{}", pluginName, dlElements);
                return crawlerBookDto;
            }
            val dlAllElements = dlElement.getAllElements();
            int isTag = 0;
            for (int i = 0; i < dlAllElements.size(); i++) {
                val element = dlAllElements.get(i);
                if (isTag != 2) {
                    if (element.tag().getName().equals("dt")) {
                        isTag += 1;
                    }
                    continue;
                }

                val aElements = element.getElementsByTag("a");
                if (CollectionUtil.isEmpty(aElements)) {
                    log.error("[Plugin Error] 查询数据失败，获取书籍章节失败(a)! pluginName：{}, element：{}", pluginName, element);
                    return crawlerBookDto;
                }
                val aElement = aElements.get(0);
                if (aElement == null || StringUtils.isBlank(aElement.attr("href")) || StringUtils.isBlank(aElement.text())) {
                    log.error("[Plugin Error] 查询数据失败，获取书籍章节失败(attr || text)! pluginName：{}, element：{}", pluginName, element);
                    return crawlerBookDto;
                }


                crawlerChatterDtoList.add(CrawlerChapterDto.builder()
                        .name(aElement.text())
                        .url(aElement.attr("href"))
                        .build());
            }


        } catch (IOException e) {
            log.error("[Plugin Error] pluginName：{}", pluginName, e);
        }


        crawlerBookDto.setChapters(crawlerChatterDtoList);
        return crawlerBookDto;
    }

    @Override
    public CrawlerChapterDto crawlerChapter(String url) {
        val chapterDto = new CrawlerChapterDto();
        chapterDto.setUrl(url);

        val client = getConnectClient();
        val request = getRequest(url);

        try (val response = client.newCall(request).execute()) {
            // 获取查询结果
            String responseBody = response.body().string();
            val doc = Jsoup.parse(responseBody);

            // 章节名
            val titleElements = doc.getElementsByTag("title");
            if (CollectionUtil.isEmpty(titleElements)) {
                log.error("[Plugin Error] 查询数据失败，获取章节名失败(title)! pluginName：{}, doc：{}", pluginName, doc);
                return chapterDto;
            }

            val titleElement = titleElements.get(0);
            if (titleElement == null || StringUtils.isBlank(titleElement.text())) {
                log.error("[Plugin Error] 查询数据失败，获取章节名失败(text)! pluginName：{}, titleElements：{}", pluginName, titleElements);
                return chapterDto;
            }
            chapterDto.setName(titleElement.text());

            // 章节内容
            val contentElement = doc.getElementById("content");
            if (contentElement == null) {
                log.error("[Plugin Error] 查询数据失败，获取章节内容失败(content)! pluginName：{}, doc：{}", pluginName, doc);
                return chapterDto;
            }
            chapterDto.setHtmlContent(contentElement.html());

        } catch (IOException e) {
            log.error("[Plugin Error] pluginName：{}", pluginName, e);
        }

        return chapterDto;
    }

    @Override
    public String getBookNameValidPlugin() {
        return null;
    }

    private OkHttpClient getConnectClient() {
        return new OkHttpClient.Builder()
                .connectTimeout(10, TimeUnit.SECONDS)
                .readTimeout(30, TimeUnit.SECONDS)
                .writeTimeout(30, TimeUnit.SECONDS)
                .build();
    }

    private Request getRequest(String url) {
        try {
            return new Request.Builder()
                    .url(url)
                    .header("User-Agent",
                            "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 " +
                                    "(KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36")
                    .build();
        } catch (Exception e) {
            log.error("[Plugin Error] URL请求构建失败！ pluginName：{}, url：{}", pluginName, url, e);
            return new Request.Builder().build();
        }
    }
}
