// app/javascript/uploader.js
(() => {
  const initImageUploader = () => {
    // アップロード領域（どちらのid/classでも可）
    const area =
      document.getElementById("js-upload-area") ||
      document.querySelector(".click-upload");
    if (!area) return;

    const form     = area.closest("form");
    const previews = form?.querySelector("#previews");
    if (!form || !previews) return;

    // 多重初期化ガード（フォーム毎）
    if (form.dataset.imageUploaderInitialized === "true") return;
    form.dataset.imageUploaderInitialized = "true";

    // 設定
    const MAX_FILES = Number(area.dataset.max || 5);

    // 既存画像の削除チェック（編集画面にのみ存在）
    const deleteCbs = Array.from(
      document.querySelectorAll('input[name="item[remove_image_ids][]"]')
    );

    // 残り枚数表示（任意）
    const remainEl = document.getElementById("js-remaining") || area.querySelector("[data-rest]");

    // 選択済み input の待避場所（submitされる）
    let selectedBin = form.querySelector("#js-selected-bin");
    if (!selectedBin) {
      selectedBin = document.createElement("div");
      selectedBin.id = "js-selected-bin";
      selectedBin.style.display = "none";
      form.appendChild(selectedBin);
    }

    // 一意な uid
    let seq = 0;
    const newUid = () => `u${Date.now()}_${++seq}`;

    // 画像カード生成
    const createPreviewCard = (file, uid, index) => {
      const blob = URL.createObjectURL(file);

      const wrap = document.createElement("div");
      wrap.className = "preview preview-new";
      wrap.dataset.index = String(index);
      wrap.dataset.uid   = uid;

      const img = document.createElement("img");
      img.className = "preview-image";
      img.src = blob;
      img.alt = `preview-${index}`;
      img.onload = () => URL.revokeObjectURL(blob);

      const actions = document.createElement("div");
      actions.className = "preview-actions";

      const rm = document.createElement("button");
      rm.type = "button";
      rm.className = "btn btn-outline-danger btn-sm remove-new";
      rm.textContent = "削除";

      rm.addEventListener("click", (ev) => {
        ev.preventDefault();
        ev.stopPropagation(); // クリック貫通でファイルダイアログが開くのを防止

        // hidden input を確実に除去（選択枚数の唯一の真実）
        const inp = selectedBin.querySelector(`[data-uid="${uid}"]`);
        if (inp) inp.remove();

        wrap.remove();

        // 一瞬の重なりによる誤クリックを避けてからUI更新
        area.style.pointerEvents = "none";
        requestAnimationFrame(() => {
          updateUI();
          setTimeout(() => { area.style.pointerEvents = ""; }, 80);
        });

        // 既存削除チェックの変化にも追従（編集画面のみ）
        deleteCbs.forEach(cb => cb.addEventListener("change", (e) => {
          const tile = e.target.closest(".existing-image");
          if (tile) tile.classList.toggle("is-removed", e.target.checked); // 見た目
          updateUI();                                                      // 枚数再計算
        }));
      });

      actions.appendChild(rm);
      wrap.appendChild(img);
      wrap.appendChild(actions);
      previews.appendChild(wrap);
    };

    // 追加用 input を1本だけ用意してイベントを付与
    const makePicker = () => {
      const input = document.createElement("input");
      input.type = "file";
      input.name = "item[images][]";
      input.accept = "image/*";
      input.dataset.uid   = newUid();
      input.dataset.index = String(selectedNew()); // 0,1,2,...

      input.addEventListener("change", () => {
        const file = input.files && input.files[0];
        if (!file) return;

        // 表示は1枚ずつ（multipleは使わない運用）
        createPreviewCard(file, input.dataset.uid, input.dataset.index);

        // このinputは確定 → hidden置き場へ退避
        input.dataset.selected = "1";
        selectedBin.appendChild(input);

        updateUI();
      });

      area.appendChild(input);
    };

    // ----- 枚数計算（ここだけを真実にする） -----
      const selectedNew    = () => selectedBin.querySelectorAll("[data-uid]").length;
      const checkedDeletes = () => deleteCbs.filter(cb => cb.checked).length;
      const existingNow    = () => form.querySelectorAll(".existing-images .existing-image").length;
      const used           = () => (existingNow() - checkedDeletes()) + selectedNew();
      const left           = () => Math.max(0, MAX_FILES - used());


    // UI更新：残り枚数・追加用inputの管理
    const updateUI = () => {
      const allow = left();

      if (remainEl) remainEl.textContent = String(allow);

      // 追加用の「空の input」は常に1本だけ／残り0なら0本
      const pickers = Array.from(
        area.querySelectorAll('input[type="file"][name="item[images][]"]:not([data-selected="1"])')
      );
      pickers.forEach(p => p.remove());

      if (allow > 0) makePicker();

      // 領域自体は隠さない（displayの二重管理はしない）。必要ならボタンだけ無効化。
      const activePicker = area.querySelector('input[type="file"][name="item[images][]"]:not([data-selected="1"])');
      if (activePicker) activePicker.disabled = allow <= 0;
    };

    // 初期化：もしマークアップに最初の<input type="file">があっても排除
    Array.from(area.querySelectorAll('input[type="file"][name="item[images][]"]'))
      .forEach(p => p.remove());

    // 既存削除チェックの変化にも追従（編集画面のみ）
    deleteCbs.forEach(cb => cb.addEventListener("change", updateUI));

    // 最初の描画
    updateUI();
  };

  document.addEventListener("turbo:load",   initImageUploader);
  document.addEventListener("turbo:render", initImageUploader);
  document.addEventListener("DOMContentLoaded", initImageUploader);
})();
