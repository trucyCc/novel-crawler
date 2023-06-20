import HomeSearch from "@/components/page/home/HomeSearch";
import HomeLogo from "@/components/page/home/HomeLogo";
import HomeSearchTable from "@/components/page/home/HomeSearchTable";

const Home = () => {
  return (
    <div className="sm:p-20 w-full h-full items-center flex justify-center  flex-col">
      <HomeLogo />
      <HomeSearch searchHttp={process.env.SERVER_HTTP} />
      <HomeSearchTable />
    </div>
  );
};

export default Home;
