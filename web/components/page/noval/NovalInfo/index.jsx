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
import { Separator } from "@/components/ui/separator";
import { useSelector, useDispatch } from "react-redux";
import { nanoid } from "nanoid";
import { useRouter } from "next/navigation";
import { toast } from "@/components/ui/use-toast";
import { Img } from "react-image";
import NovalChapterList from "../NovalChapterList";

const NovalInfo = ({ searchHttp, novalId }) => {
  // store
  const searchDataStore = useSelector((state) => state.searchData);

  // router
  const router = useRouter();

  // noval info
  const [novalInfo, setNovalInfo] = useState(undefined);
  const [novalChapters, setNovalChapters] = useState(undefined);

  useEffect(() => {
    const fetchData = async () => {
      if (!(searchDataStore.resultData.length > 0)) {
        router.push(`/`);
        return;
      }

      const novalSearchInfo = searchDataStore.resultData.find(
        (d) => d.id === novalId
      );

      if (
        novalSearchInfo === undefined ||
        novalSearchInfo.url === undefined ||
        novalSearchInfo.url.trim().length === 0
      ) {
        router.push(`/`);
        return;
      }

      const novalData = await getNovalInfo(novalSearchInfo.url);
      if (novalData.code !== 200) {
        router.push(`/`);
        return;
      }

      const chapters = novalData.data.chapters;
      novalData.data.chapters = {};
      setNovalInfo(novalData.data);
      setNovalChapters(chapters);
    };

    fetchData();
  }, []);

  // 获取Noval Info
  const getNovalInfo = async (novalUrl) => {
    const params = new URLSearchParams();
    params.append("url", novalUrl);

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
    novalInfo && (
      <div>
        <Card>
          <CardHeader>
            <CardTitle>
              <Img src={novalInfo.coverUrl} alt="Noval Image" />

              <div className="pt-4">{novalInfo.name}</div>
              <div></div>
            </CardTitle>
            <CardDescription>
              <div>{novalInfo.author}</div>
              <div>简 介：{novalInfo.intro}</div>
            </CardDescription>
          </CardHeader>
          <CardContent className="grid gap-4">
            <NovalChapterList chapters={novalChapters} />
          </CardContent>
          <CardFooter></CardFooter>
        </Card>
      </div>
    )
  );
};

export default NovalInfo;
