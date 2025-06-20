

export default function Home() {
    return (
        <div className="p-10 font-mono bg-yellow-50">
        
         <div className="mb-4 text-6xl ">
            〜基本情報〜
         </div>
         <div className="space-y-8  text-5xl" whitespace-pre-line="true">
         <p>名前：田中　葵惟</p>
            <p>生年月日：2002年 8月20日</p> 
            <p>現住所：岐阜県岐阜市</p>
            <p>特技：睡眠、バク宙</p>
            <p>趣味：睡眠</p>
            <p>こんな活動してました <a className="text-3xl bg-slate-200 shadow-md hover:shadow-xl transition-shadow hover:text-blue-600" href="https://www.youtube.com/@spiders_cheer"> 名古屋スパイダーズ</a> </p>
         </div>
         <div></div>
    </div>
    );
};