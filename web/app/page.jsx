import HomeSearch from "@/components/page/HomeSearch"
import HomeNovelShelf from "@/components/page/HomeNovelShelf"
import HomeLogo from "@/components/page/HomeLogo"
import HomeSearchTable from "@/components/page/HomeSearchTable";

const Home = () => {
  return (
      <div className="w-full h-full items-center flex justify-center  flex-col">
        <HomeLogo />
        <HomeSearch
          searchHttp={process.env.SERVER_HTTP}
        />
        <HomeSearchTable />
        {/* <HomeNovelShelf /> */}
      </div>
  )
}

export default Home