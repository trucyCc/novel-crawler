import './globals.css'
import { Inter } from 'next/font/google'
import { Toaster } from '@/components/ui/tosater'

const inter = Inter({ subsets: ['latin'] })

export const metadata = {
  title: 'Novel Crawler',
  description: '1.0 no auth no cache',
}

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body className={inter.className}>
        <main className="flex sm:p-20 justify-center w-screen h-screen ">
          {children}
        </main>
        <Toaster />
      </body>
    </html>
  )
}
