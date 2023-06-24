"use client";
import { Button } from "@/components/ui/button";
import { useRouter } from "next/navigation";
import { useSelector } from "react-redux";

const ChapterOperating = ({ chapterId }) => {
  // store
  const chaptersStore = useSelector((state) => state.chapters);

  // router
  const router = useRouter();

  const previousChapterClick = () => {
    // 从chapters中获取chapterId对应的对象
    const index = chaptersStore.chapters.findIndex(
      (chapter) => chapter.id === chapterId
    );
    const prevChapter = chaptersStore.chapters[index - 1];

    const replaceHref = window.location.href.replace(chapterId, "");
    const preChapterUrl = `${replaceHref}/${prevChapter.id}`;
    router.push(preChapterUrl);
  };

  const chapterCatalogueClick = () => {
    const replaceHref = window.location.href.replace(chapterId, "");
    router.push(replaceHref);
  };

  const nextChapterClick = () => {
    const index = chaptersStore.chapters.findIndex(
      (chapter) => chapter.id === chapterId
    );
    const nextChapter = chaptersStore.chapters[index + 1];

    const replaceHref = window.location.href.replace(chapterId, "");
    const nextChapterUrl = `${replaceHref}/${nextChapter.id}`;
    router.push(nextChapterUrl);
  };

  return (
    <div className="flex py-4">
      <div>
        <Button className="bg-blue-500" onClick={previousChapterClick}>
          上一章
        </Button>
      </div>
      <div className="px-2.5">
        <Button className="bg-green-500" onClick={chapterCatalogueClick}>
          目录
        </Button>
      </div>
      <div>
        <Button className="bg-blue-500" onClick={nextChapterClick}>
          下一章
        </Button>
      </div>
    </div>
  );
};

export default ChapterOperating;
