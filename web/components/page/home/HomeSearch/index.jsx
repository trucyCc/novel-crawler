"use client";
import { Search, Loader2 } from "lucide-react";
import React, { useState } from "react";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm } from "react-hook-form";
import * as z from "zod";
import { Input } from "@/components/ui/input";
import { Button } from "@/components/ui/button";
import {
  Select,
  SelectContent,
  SelectItem,
  SelectTrigger,
  SelectValue,
} from "@/components/ui/select";
import {
  Form,
  FormControl,
  FormField,
  FormItem,
  FormMessage,
} from "@/components/ui/form";
import { toast } from "@/components/ui/use-toast";
import { debounce } from "lodash";
import { useSelector, useDispatch } from "react-redux";
import { setStoreSearchData } from "@/stores/SearchSlice";


// form schema 验证
const FormSchema = z.object({
  searchText: z
    .string({
      required_error: "请输入内容",
    })
    .refine((value) => value.length >= 2 && value.length <= 10, {
      message: "查询内容必须在2到10个字符之间",
    }),
});

// home search
const HomeSearch = ({ searchHttp }) => {
  // 获取form
  const form = useForm({
    resolver: zodResolver(FormSchema),
  });

  // store
  const searchDataStore = useSelector((state) => state.searchData);
  const dispatch = useDispatch();

  // search button lodaing状态
  const [searchButtonLoading, setSearchButtonLoading] = useState(false);
  const setSearchButtonToLoading = () => {
    setSearchButtonLoading(true);
  };
  const setSearchButtonLoadinEnd = () => {
    setSearchButtonLoading(false);
  };

  // 提交表单，搜索指定内容
  const onSubmit = debounce(async (data) => {
    setSearchButtonToLoading();

    // 提示搜索内容
    // onSubmitMessageToast(data);

    // 获取搜索结果
    const resultData = await getSearchData(data.searchText);

    // 放入reduxf
    if (resultData.code === 200) {
      dispatch(setStoreSearchData(resultData.data));
    } else {
      errorMessageToast({ message: resultData.message });
    }

    // 解除查询按钮加载状态
    setSearchButtonLoadinEnd();
  }, 300);

  // 获取检索结果 API
  const getSearchData = async (text) => {
    const params = new URLSearchParams();
    params.append("name", text);

    const queryString = params.toString();
    const url = `${searchHttp}/crawler/query?${queryString}`;

    return await fetch(url)
      .then((response) => response.json())
      .then((data) => {
        return data;
      })
      .catch((error) => {
        setSearchButtonLoadinEnd();
        console.error("Error fetching data:", error);
        errorMessageToast(error);
      });
  };

  // toast 搜索内容
  const onSubmitMessageToast = (data) => {
    toast({
      title: "你提交的检索值:",
      description: (
        <pre className="mt-2 w-[340px] rounded-md bg-slate-950 p-4">
          <code className="text-white">{JSON.stringify(data, null, 2)}</code>
        </pre>
      ),
    });
  };

  // error message toast
  const errorMessageToast = (error) => {
    toast({
      variant: "destructive",
      title: "异常",
      description: (
        <pre className="mt-2 w-[340px] rounded-md bg-slate-950 p-4">
          <code className="text-white">{JSON.stringify(error, null, 2)}</code>
        </pre>
      ),
    });
  };

  return (
    <Form {...form} className="flex flex-shrink-0">
      <form
        onSubmit={form.handleSubmit(onSubmit)}
        className="flex items-center py-9 w-10/12 "
      >
        {/* 目标源设置 */}
        <FormField
          control={form.control}
          name="source"
          defaultValue="ibiqu.org"
          render={({ field }) => (
            <FormItem className="sm:w-4/12 w-4/12 truncate">
              <Select onValueChange={field.onChange} defaultValue={field.value}>
                <FormControl>
                  <SelectTrigger>
                    <SelectValue placeholder="目标源" />
                  </SelectTrigger>
                </FormControl>
                <SelectContent>
                  <SelectItem value="all">全部（查询时间长）</SelectItem>
                  <SelectItem value="ibiqu.org">ibiqu.org</SelectItem>
                </SelectContent>
              </Select>
              <FormMessage className="absolute" />
            </FormItem>
          )}
        />

        {/* 搜索内容 */}
        <FormField
          control={form.control}
          name="searchText"
          defaultValue=""
          render={({ field }) => (
            <FormItem className="sm:w-full w-7/12">
              <FormControl>
                <Input placeholder="输入作者或者书名" {...field} />
              </FormControl>
              <FormMessage className="absolute" />
            </FormItem>
          )}
        />

        {/* 提交按钮 */}
        <Button
          disabled={searchButtonLoading}
          type="submit"
          className="sm:w-3/12 w-2/12	"
        >
          {searchButtonLoading ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Search className="sm:mr-2 sm:h-4 sm:w-4" />
          )}
          <div className="hidden sm:flex">查询</div>
        </Button>
      </form>
    </Form>
  );
};

export default HomeSearch;
