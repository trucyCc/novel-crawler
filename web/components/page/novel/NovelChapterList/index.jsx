"use client";
import { Separator } from "@/components/ui/separator";
import { nanoid } from "nanoid";
import { useRouter } from "next/navigation";

const NovelChapterList = ({ chapters }) => {
  // router
  const router = useRouter();

  const chapterOnClick = async (row) => {
    const url = `${window.location.href}/${row.id}`
    router.push(url)
  };

  return (
    chapters && (
      <div className="sm:grid sm:gap-6 sm:grid-cols-3">
        {chapters.map((row) => (
          <div
            key={nanoid()}
            className="hover:underline hover:cursor-pointer"
            onClick={() => chapterOnClick(row)}
          >
            <div>{row.name}</div>
            <Separator className="my-2" />
          </div>
        ))}
      </div>
    )
  );
};

export default NovelChapterList;
