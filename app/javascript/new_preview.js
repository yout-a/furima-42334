// 新規選択画像のプレビュー
document.addEventListener("turbo:load", () => {
  const area = document.getElementById("js-upload-area");
  if (!area) return;

  const input = area.querySelector('input[type="file"]');
  const box   = document.getElementById("previews");
  if (!input || !box) return;

  const makeThumb = (file) => {
    const url = URL.createObjectURL(file);
    const img = document.createElement("img");
    img.src = url;
    img.alt = file.name;
    img.className = "preview-thumb";
    img.onload = () => URL.revokeObjectURL(url);
    return img;
  };

  input.addEventListener("change", (e) => {
    const files = Array.from(e.target.files || []);
    box.innerHTML = "";                    // 前回の選択をクリア
    files.forEach((f) => {
      if (!f.type.startsWith("image/")) return;
      const cell = document.createElement("div");
      cell.className = "preview-cell";
      cell.appendChild(makeThumb(f));
      box.appendChild(cell);
    });
  });
});
