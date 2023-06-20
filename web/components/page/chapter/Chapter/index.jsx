"use client";
import ChapterContent from "@/components/page/chapter/ChapterContent";
import ChapterOperating from "@/components/page/chapter/ChapterOperating";
import ChapterTitle from "@/components/page/chapter/ChapterTitle";
import React, { useState, useEffect } from "react";
import { useSelector } from "react-redux";
import { useRouter } from "next/navigation";
import ChapterFooter from "../ChapterFooter/ChapterFooter";

const ChapterLayout = ({ chapterId, serverHttp }) => {
  // store
  const chaptersStore = useSelector((state) => state.chapters);

  // router
  const router = useRouter();

  const [chapterTitle, setChapterTitle] = useState("")
  const [chapterContent, setChapterContent] = useState("")

  useEffect(() => {
    const fetchData = async () => {
      if (!(chaptersStore.chapters.length > 0)) {
        router.push(`/`);
        return;
      }

      const chapterInfo = chaptersStore.chapters.find(
        (d) => d.id === chapterId
      );

      if (
        chapterInfo === undefined ||
        chapterInfo.url === undefined ||
        chapterInfo.url.trim().length === 0
      ) {
        router.push(`/`);
        return;
      }

      const result = await getChapterContent(chapterInfo.url);
      console.log(result);

      if(result.code !== 200) {
        router.push(`/`);
        return;
      }

      const resultData = result.data;

      setChapterTitle(resultData.name)
      setChapterContent(resultData.htmlContent)
    };

    fetchData();
  }, []);

  const getChapterContent = async (chapterUrl) => {
    const params = new URLSearchParams();
    params.append("url", chapterUrl);

    const queryString = params.toString();
    const url = `${serverHttp}/crawler/chapter`;

    return await fetch(url, {
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: queryString,
    })
      .then((response) => response.json())
      .then((data) => {
        return data;
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
      });
  };

  return (
    <div className="flex items-center flex-col">
      <ChapterTitle 
        title={chapterTitle}
      />
      {chapterContent && <ChapterOperating 
        chapterId={chapterId}
      />}
      <ChapterContent 
        content={chapterContent}
      />
      {chapterContent && <ChapterOperating 
        chapterId={chapterId}
      />}
      <ChapterFooter
        chapterId={chapterId}
      />
    </div>
  );
};

export default ChapterLayout;
