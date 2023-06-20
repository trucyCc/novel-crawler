import NovalInfo from "@/components/page/noval/NovalInfo";


const NovalPage = ({params}) => {
  return (
    <div className="w-full h-full  flex  flex-col sm:p-10 p-3 overflow-auto">
        <NovalInfo  
            novalId={params.novalId}
            searchHttp={process.env.SERVER_HTTP}
        />
    </div>
  );
};

export default NovalPage;
