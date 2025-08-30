document.addEventListener("turbo:load", () => {
  const area = document.getElementById("js-upload-area");
  if (!area) return;

  const max  = Number(area.dataset.max || 5);
  const base = Number(area.dataset.existing || 0);

  const input     = document.getElementById("new-images-input");
  const previews  = document.getElementById("previews");
  const remainEl  = document.getElementById("js-remaining");
  const deleteCbs = document.querySelectorAll('input[name="item[remove_image_ids][]"]');

  const checkedDeletes = () => Array.from(deleteCbs).filter(cb => cb.checked).length;
  const currentCount   = () => base - checkedDeletes();
  const left           = () => Math.max(0, max - currentCount());

  const renderPreviews = (files) => {
    previews.innerHTML = "";
    Array.from(files).forEach((f) => {
      if (!f.type.startsWith("image/")) return;
      const url = URL.createObjectURL(f);
      const img = document.createElement("img");
      img.src = url;
      img.className = "preview-thumb";
      img.onload = () => URL.revokeObjectURL(url);
      const cell = document.createElement("div");
      cell.className = "preview-cell";
      cell.appendChild(img);
      previews.appendChild(cell);
    });
  };

  const clampSelection = () => {
    const allow = left();
    const files = Array.from(input.files || []);
    if (files.length > allow) {
      alert(`選べるのはあと ${allow} 枚までです。`);
      const dt = new DataTransfer();
      files.slice(0, allow).forEach(f => dt.items.add(f));
      input.files = dt.files;
    }
    renderPreviews(input.files);
  };

  const refresh = () => {
    const allow = left();
    if (remainEl) remainEl.textContent = allow;
    area.style.display = allow <= 0 ? "none" : "";
  };

  refresh();
  deleteCbs.forEach(cb => cb.addEventListener("change", () => { refresh(); clampSelection(); }));
  if (input) input.addEventListener("change", clampSelection);
});

