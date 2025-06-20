import Link from 'next/link';

export default function HomePage() {
  return (
    
    <div className="homepage  p-6 text-center">
      <h1 className="text-4xl font-bold text-blue-900">！自己紹介！</h1>
      <p className="text-lg text-gray-700 mt-4">
ボタンをクリックすると自己紹介ページに飛びます、ぜひご覧ください
      </p>
      <div className="hover:scale-125 hover:border-b-lime-400">
      <Link href="http://localhost:3000/top/about"><button  className="mt-6 px-4 py-2 bg-blue-600 text-white rounded hover:bg-blue-700">
        自己紹介を見る
      </button></Link>
      </div>
    </div>
  );
}



