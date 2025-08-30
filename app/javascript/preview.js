const initMultiPreview = () => {
  const uploadArea = document.querySelector('.click-upload');
  if (!uploadArea) return;

  const form     = uploadArea.closest('form');
  const previews = form?.querySelector('#previews');
  if (!form || !previews) return;

  if (form.dataset.multiPreviewInitialized === 'true') return;
  form.dataset.multiPreviewInitialized = 'true';

  const MAX_FILES = Number(uploadArea.dataset.max || 5);
  const existing  = Number(uploadArea.dataset.existing || 0);

  // 選択済み input の待避場所（submit される）
  let selectedBin = form.querySelector('#js-selected-bin');
  if (!selectedBin) {
    selectedBin = document.createElement('div');
    selectedBin.id = 'js-selected-bin';
    selectedBin.style.display = 'none';
    form.appendChild(selectedBin);
  }

  let seq = 0;
  const newUid = () => `u${++seq}`;

  const createPreviewCard = (file, uid, index) => {
    const old = previews.querySelector(`.preview[data-index="${index}"]`);
    if (old) old.remove();

    const blob = URL.createObjectURL(file);

    const wrap = document.createElement('div');
    wrap.className = 'preview preview-new';
    wrap.dataset.index = String(index);
    wrap.dataset.uid   = uid;

    const img = document.createElement('img');
    img.className = 'preview-image';
    img.src = blob;
    img.alt = `preview-${index}`;
    img.onload = () => URL.revokeObjectURL(blob);

    const actions = document.createElement('div');
    actions.className = 'preview-actions';

    const rm = document.createElement('button');
    rm.type = 'button';
    rm.className = 'btn btn-outline-danger btn-sm remove-new';
    rm.textContent = '削除';

    rm.addEventListener('click', (ev) => {
      ev.preventDefault();
      const inp =
        selectedBin.querySelector(`input[type="file"][name="item[images][]"][data-uid="${uid}"]`) ||
        uploadArea.querySelector(`input[type="file"][name="item[images][]"][data-uid="${uid}"]`);
      if (inp) inp.remove();
      wrap.remove();
      updateUploadInputs();        // 足りなければアップロード領域を再表示
    });

    actions.appendChild(rm);
    wrap.appendChild(img);
    wrap.appendChild(actions);
    previews.appendChild(wrap);
  };

  // アップロード領域の表示と「空 input 1本」を管理
  const updateUploadInputs = () => {
    const allInputs = [
      ...uploadArea.querySelectorAll('input[type="file"][name="item[images][]"]'),
      ...selectedBin.querySelectorAll('input[type="file"][name="item[images][]"]'),
    ];
    const selectedNew = allInputs.filter(i => i.files?.length).length;
    const total = existing + selectedNew;

    if (total >= MAX_FILES) {
      uploadArea.classList.add('is-collapsed');    // 5枚到達 → 常時非表示
      uploadArea.querySelectorAll('input[type="file"][name="item[images][]"]').forEach(i => i.remove());
      return;
    }

    // 今見えている空 input は 1 本だけにする
    const empties = [...uploadArea.querySelectorAll('input[type="file"][name="item[images][]"]')]
      .filter(i => !i.files?.length);
    empties.slice(1).forEach(i => i.remove());

    if (empties.length === 0) {
      const index = selectedNew;                   // 0,1,2,...
      const input = document.createElement('input');
      input.type = 'file';
      input.name = 'item[images][]';
      input.accept = 'image/*';
      input.dataset.index = String(index);
      input.dataset.uid   = newUid();
      uploadArea.appendChild(input);
    }

    // 次の空 input が用意できたら再表示（＝プレビューと同時に見えない）
    uploadArea.classList.remove('is-collapsed');
  };

  // 画像選択時：まずアップロード領域を畳む → プレビュー描画 → input を退避 → 次の空 input を用意
  uploadArea.addEventListener('change', (e) => {
    const input = e.target;
    if (!(input instanceof HTMLInputElement)) return;
    if (input.type !== 'file' || input.name !== 'item[images][]') return;

    const file  = input.files && input.files[0];
    const index = input.dataset.index || '0';
    if (!file) return;

    // プレースホルダーとプレビューが同時に見えないよう、いったん隠す
    uploadArea.classList.add('is-collapsed');

    createPreviewCard(file, input.dataset.uid, index);

    // この input は確定として不可視の置き場へ（再選択できない＝プレビュー固定）
    input.dataset.selected = '1';
    selectedBin.appendChild(input);

    // 次の空 input を 1 本だけ用意（あれば再表示）
    updateUploadInputs();
  });

  // 初期化
  updateUploadInputs();
};

document.addEventListener('turbo:load',       initMultiPreview);
document.addEventListener('turbo:render',     initMultiPreview);
document.addEventListener('DOMContentLoaded', initMultiPreview);