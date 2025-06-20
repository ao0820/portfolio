"use client";
import { useState } from "react";

export default function ContactForm() {
  const [email, setEmail] = useState("");
  const [confirmEmail, setConfirmEmail] = useState("");
  const [name, setName] = useState("");
  const [tel1, setTel1] = useState("");
  const [tel2, setTel2] = useState("");
  const [tel3, setTel3] = useState("");
  const [category,setCategory] = useState("");
  const [message, setMessage] = useState("");

  const [result, setResult] = useState('');

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    const res = await fetch('/api/contacts', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ name, email }),
    });
    const data = await res.json();
    setResult(data.message);
  };

return (
    <form onSubmit={handleSubmit} className="space-y-4 max-w-md mx-auto p-6 bg-white rounded shadow">
      <h2 className="text-xl font-bold">お問い合わせフォーム</h2>


      {/* 氏名 */}
      <input
        type="text"
        placeholder="お名前"
        value={name}
        onChange={(e) => setName(e.target.value)}
        className="w-full border px-3 py-2 rounded"
      />
      
      {/* メールアドレス */}
      <input
        type="email"
        placeholder="メールアドレス"
        value={email}
        onChange={(e) => setEmail(e.target.value)}
        className="w-full border px-3 py-2 rounded"
      />

      <input
        type="email"
        placeholder="メールアドレス"
        value={confirmEmail}
        onChange={(e) => setConfirmEmail(e.target.value)}
        className="w-full border px-3 py-2 rounded"
      />

          {/* 電話番号 */}
      <div>
           <label className="block font-medium mb-1">電話番号</label>
           <div className="flex gap-2">
             <input
              type="text"
              value={tel1}
              onChange={(e) => setTel1(e.target.value)}
              className="w-1/4 border px-3 py-2 rounded"
              maxLength={4}
            />
            <p className="pt-2">-</p>
            <input
              type="text"
              value={tel2}
              onChange={(e) => setTel2(e.target.value)}
              className="w-1/4 border px-3 py-2 rounded"
              maxLength={4}
            />
            <p className="pt-2">-</p>
            <input
              type="text"
              value={tel3}
              onChange={(e) => setTel3(e.target.value)}
              className="w-1/4 border px-3 py-2 rounded"
              maxLength={4}
            />
          </div>
        </div>

 {/* お問い合わせ種別 */}
        <div>
          <label className="block font-medium mb-2">
            お問い合わせ種別 {/*<span className="text-red-500">*</span>*/}
          </label>
          <div className="space-y-2 pl-4">
            <label className="flex items-center gap-2">
              <input
                type="radio"
                name="category"
                value="商品"
                onChange={(e) => setCategory(e.target.value)}
              />
              A
            </label>
            <label className="flex items-center gap-2">
              <input
                type="radio"
                name="category"
                value="契約"
                onChange={(e) => setCategory(e.target.value)}
              />
              B
            </label>
            <label className="flex items-center gap-2">
              <input
                type="radio"
                name="category"
                value="その他"
                onChange={(e) => setCategory(e.target.value)}
              />
              その他の問い合わせ
            </label>
          </div>
        </div>

          {/* お問い合わせ内容 */}
         <div>
           <label className="block font-medium mb-1">お問い合わせ内容</label>
           <textarea
            value={message}
            onChange={(e) => setMessage(e.target.value)}
            rows={4}
            className="w-full border px-3 py-2 rounded"
          ></textarea>
        </div>

{/* ▼ プレビューセクション ▼ */}
      <div className=" mt-10 p-6 w-full max-w-2xl rounded-lg shadow-inner text-sm text-gray-700 space-y-2">
        <h2 className="text-lg font-semibold border-b pb-2">プレビュー</h2>
        <p><strong>メールアドレス：</strong>{email}</p>
        <p><strong>確認メール：</strong>{confirmEmail}</p>
        <p><strong>氏名：</strong>{name}</p>
        <p><strong>電話番号：</strong>{tel1}-{tel2}-{tel3}</p>
        <p><strong>お問い合わせ種別：</strong>{category}</p>
        <p><strong>お問い合わせ内容：</strong>{message}</p>
      </div>

      <button type="submit" className="w-full bg-blue-600 text-white py-2 rounded">
        送信
      </button>
      {result && <p className="mt-4 text-green-600 font-semibold">{result}</p>}
    </form>
  );



















//   return (
//     <main className="flex flex-col items-center justify-center  py-10 min-h-screen">
//       {/* フォーム本体 */}
//       <form onSubmit={handleSubmit} className=" p-8 rounded-lg shadow-md w-full max-w-2xl space-y-6">
//         <h1 className="text-2xl font-bold text-gray-700">お問い合わせ</h1>

//         {/* メールアドレス */}
//         <div>
//           <label className="block font-medium mb-1">メールアドレス</label>
//           <input
//             type="email"
//             value={email}
//             onChange={(e) => setEmail(e.target.value)}
//             className="w-full border px-3 py-2 rounded"
//           />
//           <input
//             type="email"
//             placeholder="（確認用）"
//             value={confirmEmail}
//             onChange={(e) => setConfirmEmail(e.target.value)}
//             className="w-full mt-2 border px-3 py-2 rounded"
//           />
//         </div>

//         {/* 氏名 */}
//         <div>
//           <label className="block font-medium mb-1">氏名</label>
//           <input
//             type="text"
//             value={name}
//             onChange={(e) => setName(e.target.value)}
//             className="w-full border px-3 py-2 rounded"
//           />
//         </div>

//         {/* 電話番号 */}
//         <div>
//           <label className="block font-medium mb-1">電話番号</label>
//           <div className="flex gap-2">
//             <input
//               type="text"
//               value={tel1}
//               onChange={(e) => setTel1(e.target.value)}
//               className="w-1/4 border px-3 py-2 rounded"
//               maxLength={4}
//             />
//             <p className="pt-2">-</p>
//             <input
//               type="text"
//               value={tel2}
//               onChange={(e) => setTel2(e.target.value)}
//               className="w-1/4 border px-3 py-2 rounded"
//               maxLength={4}
//             />
//             <p className="pt-2">-</p>
//             <input
//               type="text"
//               value={tel3}
//               onChange={(e) => setTel3(e.target.value)}
//               className="w-1/4 border px-3 py-2 rounded"
//               maxLength={4}
//             />
//           </div>
//         </div>

       

//         {/* お問い合わせ内容 */}
//         <div>
//           <label className="block font-medium mb-1">お問い合わせ内容</label>
//           <textarea
//             value={message}
//             onChange={(e) => setMessage(e.target.value)}
//             rows={4}
//             className="w-full border px-3 py-2 rounded"
//           ></textarea>
//         </div>

// {/* ▼ プレビューセクション ▼ */}
//       <div className=" mt-10 p-6 w-full max-w-2xl rounded-lg shadow-inner text-sm text-gray-700 space-y-2">
//         <h2 className="text-lg font-semibold border-b pb-2">プレビュー</h2>
//         <p><strong>メールアドレス：</strong>{email}</p>
//         <p><strong>確認メール：</strong>{confirmEmail}</p>
//         <p><strong>氏名：</strong>{name}</p>
//         <p><strong>電話番号：</strong>{tel1}-{tel2}-{tel3}</p>
//         <p><strong>お問い合わせ種別：</strong>{category}</p>
//         <p><strong>お問い合わせ内容：</strong>{message}</p>
//       </div>

//         {/* 送信ボタン */}
//         <div className="text-center pt-4">
//           <button
//             type="submit"
//             className="bg-gray-700 hover:bg-gray-800 text-white px-8 py-2 rounded text-lg"
//           >
//             送信
//           </button>
//           {result && <p className="mt-4 text-green-600 font-semibold">{result}</p>}
//         </div>
//       </form>

 
//     </main>
//   );
}
