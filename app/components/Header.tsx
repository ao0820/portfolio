import Link from "next/link";

 
 export default function Header() {
    return(
 <header className=" bg-gray-800 text-white p-6 font-bold">
          <div className="w-full flex justify-between">
            <div><Link href="/top/about" className="text-white hover:text-gray-400">基本情報</Link></div>
            <div><Link href="/top" className="text-white hover:text-gray-400">PR</Link></div>
            <div><Link href="/top/skill" className="text-white hover:text-gray-400">学び</Link></div>

            <div><Link href="/top/about/work/contact" className="text-white hover:text-gray-400">連絡先</Link></div>
          </div>
          
         
        </header>
    );
 }