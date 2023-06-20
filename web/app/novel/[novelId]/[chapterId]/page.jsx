import ChapterLayout from "@/components/page/chapter/Chapter";


const ChapterPage = ({ params }) => {
  return (
    <div className="w-full h-full items-center flex  flex-col overflow-auto bg-yellow-100 text-gray-700 p-4 line-height-[1.5] text-base font-sans">
      <div className="pt-3" />
      <ChapterLayout 
        chapterId={params.chapterId}
        serverHttp={process.env.SERVER_HTTP}
      />
    </div>
  );
};

export default ChapterPage;
