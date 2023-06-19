"use client";
import { Search } from "lucide-react";

import Link from "next/link";
import { zodResolver } from "@hookform/resolvers/zod";
import { useForm, Controller } from "react-hook-form";
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
  FormDescription,
  FormField,
  FormItem,
  FormLabel,
  FormMessage,
} from "@/components/ui/form";

import { toast } from "@/components/ui/use-toast";

const FormSchema = z.object({
  searchText: z
    .string({
      required_error: "请输入内容",
    })
    .refine((value) => value.length >= 2 && value.length <= 10, {
      message: "查询内容必须在2到10个字符之间",
    }),
});

const HomeSearch = () => {
  const form = useForm({
    resolver: zodResolver(FormSchema),
  });

  function onSubmit(data) {
    toast({
      title: "You submitted the following values:",
      description: (
        <pre className="mt-2 w-[340px] rounded-md bg-slate-950 p-4">
          <code className="text-white">{JSON.stringify(data, null, 2)}</code>
        </pre>
      ),
    });
  }

  return (
    <Form {...form} className="flex flex-shrink-0">
      <form
        onSubmit={form.handleSubmit(onSubmit)}
        className="flex items-center pb-10 w-10/12"
      >
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

        <Button type="submit" className="sm:w-3/12 w-2/12	">
          <Search className="sm:mr-2 sm:h-4 sm:w-4" />
          <div className="hidden sm:flex">查询</div>
        </Button>
      </form>
    </Form>
  );
};

export default HomeSearch;
