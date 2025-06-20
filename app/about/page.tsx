//import Image from "next/image";
//import styles from "./page.module.css";

export default function Home() {
    return (
      <div className="w-full h-screen grid   grid-row-3   bg-red-600 ">
        <div className="flex justify-between mt-10 mr-10 ml-10 bg-blue-400">
          <div>左上</div>
          <div>上</div>
          <div>右上</div>
        </div>
  
        <div className=" flex justify-between  mr-10 ml-10 items-center  bg-blue-200">
          <div>左</div>
          <div>中央</div>
          <div>右</div>
        </div>
  
        <div className="flex justify-between justify-items-center mr-10 ml-10 mb-10 items-end bg-blue-400">
          <div>左下</div>
          <div>下</div>
          <div>右下</div>
        </div>
  
      </div>
  
  
  
  
    );
  }