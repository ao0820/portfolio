console.log("main.js!!");

document.getElementById("btnA").addEventListener("click", function() {
    document.getElementById("main-header").classList.remove("bg-dark", "bg-primary", "bg-secondary");
    document.getElementById("main-header").classList.add("bg-danger"); // 赤色
  });

  document.getElementById("btnB").addEventListener("click", function() {
    document.getElementById("main-header").classList.remove("bg-dark", "bg-danger", "bg-secondary");
    document.getElementById("main-header").classList.add("bg-primary"); // 青色
  });
