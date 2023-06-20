"use client";
import { ScrollArea } from "@/components/ui/scroll-area";
import { Separator } from "@/components/ui/separator";
import { nanoid } from "nanoid";

const NovalChapterList = ({ chapters }) => {
  return (
    chapters && (
      //   <ScrollArea className="h-72  border grid gap-4 grid-cols-2">
      //     {/* <div className=""> */}
      //     {chapters.map((row) => (
      //       <div>
      //         <div key={nanoid()}>{row.name}</div>
      //         <Separator className="my-2" />
      //       </div>
      //     ))}
      //     {/* </div> */}
      //   </ScrollArea>
    //   <ScrollArea className="h-72 w-full rounded-md border p-4 sm:h-96	">
        <div className="sm:grid sm:gap-6 sm:grid-cols-3">
          {chapters.map((row) => (
            <div
              key={nanoid()}
              className="hover:underline hover:cursor-pointer"
            >
              <div>{row.name}</div>
              <Separator className="my-2" />
            </div>
          ))}
        </div>
    //   </ScrollArea>
    )
  );
};

export default NovalChapterList;
