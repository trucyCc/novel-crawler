"use client";
import { Button } from "@/components/ui/button";
import { useRouter } from "next/navigation";

const ChapterOperating = ({ chapterId }) => {
  // router
  const router = useRouter();

  const previousChapterClick = () => {
    const preChapterId = parseInt(chapterId) - 1;
    const replaceHref = window.location.href.replace(chapterId, "")
    const preChapterUrl = `${replaceHref}/${preChapterId}`
    router.push(preChapterUrl);
  };

  const chapterCatalogueClick = () => {
    const replaceHref = window.location.href.replace(chapterId, "")
    router.push(replaceHref);
  };

  const nextChapterClick = () => {
    const nextChapterId = parseInt(chapterId) + 1;
    const replaceHref = window.location.href.replace(chapterId, "")
    const nextChapterUrl = `${replaceHref}/${nextChapterId}`
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
