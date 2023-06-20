import React from "react";

const ChapterContent = ({ content }) => {
  return (
    <div className="leading-10 sm:w-4/6 sm:text-2xl sm:leading-loose	">
      <div dangerouslySetInnerHTML={{ __html: content }}></div>
    </div>
  );
};

export default ChapterContent;
