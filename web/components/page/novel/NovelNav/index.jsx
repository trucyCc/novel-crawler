"use client";

import { ArrowLeftFromLine } from "lucide-react";
import { useRouter } from "next/navigation";

const NovelNav = () => {
  // router
  const router = useRouter();

  const goBack = () => {
    router.push("/")
  };

  return (
    <div onClick={goBack}>
      <ArrowLeftFromLine className="h-9 w-9 cursor-pointer transition duration-500 ease-in-out transform hover:scale-110" />
      <div className="pb-6 "></div>
    </div>
  );
};

export default NovelNav;
