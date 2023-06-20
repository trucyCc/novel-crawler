"use client"
import ChapterContent from "@/components/page/chapter/ChapterContent";
import ChapterOperating from "@/components/page/chapter/ChapterOperating";
import ChapterTitle from "@/components/page/chapter/ChapterTitle";
import React, { useState, useEffect } from "react";
import { useSelector } from "react-redux";
import { useRouter } from "next/navigation";


const ChapterPage = ({ params }) => {
  // store
  const chaptersStore = useSelector((state) => state.chapters)

  // router
  const router = useRouter();

  useEffect(() => {
    const fetchData = async () => {
      if (!(chaptersStore.chapters.length > 0)) {
        router.push(`/`);
        return;
      }
    }

    fetchData()
  }, []);

  return (
    <div className="w-full h-full items-center flex justify-center  flex-col overflow-auto bg-yellow-100 text-gray-700 p-4 line-height-[1.5] text-base font-sans">
      <div>chapterID: {params.chapterId}</div>
      <ChapterTitle />
      <ChapterOperating />
      <ChapterContent />
      <ChapterOperating />
    </div>
  );
};

export default ChapterPage;
