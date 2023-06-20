import NovelInfo from "@/components/page/novel/NovelInfo";


const NovelPage = ({params}) => {
  return (
    <div className="w-full h-full  flex  flex-col sm:p-10 p-3 overflow-auto">
        <NovelInfo  
            novelId={params.novelId}
            searchHttp={process.env.SERVER_HTTP}
        />
    </div>
  );
};

export default NovelPage;
