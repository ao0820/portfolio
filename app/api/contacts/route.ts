import { NextResponse } from "next/server";

// app/api/contact/route.ts
type ContactRequest = {
  // 変数定義の部分を状況に合わせて変更
  email: string;
  confirmEmail: string;
  name: string;
  tel1: number;
  tel2: number;
  tel3: number;
  category: string;
  message: string;

};



export async function POST(req: Request) {
	// 関数内で使用できるように{ }の中で取り出す。
  const { name, email,tel1, tel2, tel3, category, message }: ContactRequest = await req.json();
  console.log("受信したデータ:", name, email,tel1, tel2, tel3, category, message);

  // フロントエンドにデータを返す場合はこちらのmessageに変数を組み込んで返してください。
  return NextResponse.json({
    message: `${name}さん、ありがとうございます！
    メール(${email})
    電話番号(${tel1}-${tel2}-${tel3})
    お問い合わせ種別(${category})
    お問い合わせ内容(${message})
    を受け取りました。`
  });
}