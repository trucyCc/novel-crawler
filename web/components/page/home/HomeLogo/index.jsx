"use client";
import Image from "next/image";
import { useSelector } from "react-redux";

const HomeLogo = () => {
  // store
  const searchDataStore = useSelector((state) => state.searchData);

  return (
    !(searchDataStore.resultData.length > 0) && (
      <div className="absolute top-20 ">
        <Image
          src="/assets/images/home_logo_image.png"
          alt="Trucy Logo"
          className="drop-shadow-2xl rounded-lg"
          width={200}
          height={200}
          priority
        />
      </div>
    )
  );
};

export default HomeLogo;
