"use client";
import "./globals.css";
import { Inter } from "next/font/google";
import { Toaster } from "@/components/ui/tosater";
import { Provider } from "react-redux";
import store from "@/stores/store";

const inter = Inter({ subsets: ["latin"] });


export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <Provider store={store}>
          <main className="flex  justify-center w-screen h-screen ">
            {children}
          </main>
        </Provider>
        <Toaster />
      </body>
    </html>
  );
}
