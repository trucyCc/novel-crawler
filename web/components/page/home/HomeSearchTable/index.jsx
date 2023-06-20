"use client";
import Link from "next/link";
import React, { useState, useContext, useEffect } from "react";
import { useSelector, useDispatch } from "react-redux";
import { nanoid } from "nanoid";
import {
  Table,
  TableBody,
  TableCaption,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { useRouter } from 'next/navigation';


const HomeSearchTable = () => {
  // store
  const searchDataStore = useSelector((state) => state.searchData);

  // router
  const router = useRouter();

  return (
    searchDataStore.resultData.length > 0 && (
      <Table>
        <TableCaption>
          仅显示前50条，请输入更详细的搜索条件，缩写搜索范围.
        </TableCaption>
        <TableHeader>
          <TableRow>
            <TableHead>书名</TableHead>
            <TableHead>作者</TableHead>
            <TableHead>最新章节</TableHead>
            <TableHead className="sm:table-cell hidden">最后更新时间</TableHead>
            <TableHead className="sm:table-cell hidden">连载状态</TableHead>
            <TableHead className="text-right sm:table-cell  hidden">总字数</TableHead>
          </TableRow>
        </TableHeader>
        <TableBody>
          {searchDataStore.resultData.map((row) => (
            <TableRow
              key={nanoid()}
              onClick={() => {
                console.log(row);
                router.push(`noval/${row.id}`)
              }}
            >
              <TableCell className="font-medium">{row.name}</TableCell>
              <TableCell>{row.author}</TableCell>
              <TableCell>{row.lastChapterName}</TableCell>
              <TableCell className="sm:table-cell hidden">
                {row.lastUpdateTime}
              </TableCell>
              <TableCell className="sm:table-cell hidden">{row.status}</TableCell>
              <TableCell className="text-right sm:table-cell hidden">
                {row.wordCount}
              </TableCell>
            </TableRow>
          ))}
        </TableBody>
      </Table>
    )
  );
};

export default HomeSearchTable;
