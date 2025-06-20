// src/app/layout.tsx
import Header from "./components/Header";
import "./globals.css";
import image from 'next/image';

export const metadata = {
  title: "My Next App",
  description: "Next.jsサンプルアプリ",
};


export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="ja">
      <body className="w-full h-screen">
        <Header/>

        <main className="   font-mono bg-yellow-50">{children}</main>
        <h2 className="text-xl font-semibold mb-2"></h2>
        <footer className="bg-gray-100 text-center p-4  text-sm">共通フッター</footer>
      </body>
    </html>
  );
}