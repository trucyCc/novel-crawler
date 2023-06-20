"use client";
import React, { useState, useEffect } from "react";

import {
  Card,
  CardContent,
  CardDescription,
  CardFooter,
  CardHeader,
  CardTitle,
} from "@/components/ui/card";
import { useSelector, useDispatch } from "react-redux";
import { useRouter } from "next/navigation";
import { Img } from "react-image";
import NovelChapterList from "../NovelChapterList";
import { setStoreChapters } from "@/stores/ChapterSlice";

const NovelInfo = ({ searchHttp, novelId }) => {
  // store
  const searchDataStore = useSelector((state) => state.searchData);
  const chaptersStore = useSelector((state) => state.chapters)
  const dispatch = useDispatch();

  // router
  const router = useRouter();

  // novel info
  const [novelInfo, setNovelInfo] = useState(undefined);
  const [novelChapters, setNovelChapters] = useState(undefined);

  useEffect(() => {
    const fetchData = async () => {
      if (!(searchDataStore.resultData.length > 0)) {
        router.push(`/`);
        return;
      }

      const novelSearchInfo = searchDataStore.resultData.find(
        (d) => d.id === novelId
      );

      if (
        novelSearchInfo === undefined ||
        novelSearchInfo.url === undefined ||
        novelSearchInfo.url.trim().length === 0
      ) {
        router.push(`/`);
        return;
      }

      const novelData = await getNovelInfo(novelSearchInfo.url);
      if (novelData.code !== 200) {
        router.push(`/`);
        return;
      }

      const chapters = novelData.data.chapters;
      novelData.data.chapters = {};
      setNovelInfo(novelData.data);
      setNovelChapters(chapters);
      dispatch(setStoreChapters(chapters));
    };

    fetchData();
  }, []);

  // 获取Novel Info
  const getNovelInfo = async (novelUrl) => {
    const params = new URLSearchParams();
    params.append("url", novelUrl);

    const queryString = params.toString();
    const url = `${searchHttp}/crawler/book`;

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
    novelInfo && (
      <div>
        <Card>
          <CardHeader>
            <CardTitle>
              <Img src={novelInfo.coverUrl} alt="Novel Image" />

              <div className="pt-4">{novelInfo.name}</div>
              <div></div>
            </CardTitle>
            <CardDescription>
              <div>{novelInfo.author}</div>
              <div>简 介：{novelInfo.intro}</div>
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-4">
            <NovelChapterList chapters={novelChapters} />
          </CardContent>
          <CardFooter></CardFooter>
        </Card>
      </div>
    )
  );
};

export default NovelInfo;
