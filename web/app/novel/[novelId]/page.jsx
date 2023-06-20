import NovelInfo from "@/components/page/novel/NovelInfo";
import NovelNav from "@/components/page/novel/NovelNav";

const NovelPage = ({ params }) => {
  return (
    <div className="w-full h-full  flex  flex-col sm:p-10 p-3 overflow-auto">
      <NovelNav />
      <NovelInfo
        novelId={params.novelId}
        searchHttp={process.env.SERVER_HTTP}
      />
    </div>
  );
};

export default NovelPage;
