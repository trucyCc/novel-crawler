import HomeSearch from "@/components/page/HomeSearch"
import HomeNovelShelf from "@/components/page/HomeNovelShelf"
import HomeLogo from "@/components/page/HomeLogo"

const Home = () => {
  return (
    <div className="w-full h-full items-center flex justify-center  flex-col">
      <HomeLogo />
      <HomeSearch />
      {/* <HomeNovelShelf /> */}
    </div>
  )
}

export default Home