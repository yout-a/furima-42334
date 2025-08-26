const initPreview = () => {
  const imageInput = document.getElementById('item-image');
  if (!imageInput) return; 

  console.log("preview.jsが読み込まれました");

  imageInput.addEventListener('change', (e) => {
    const file = e.target.files && e.target.files[0];
    if (!file) return;

    let previewBox = document.getElementById('previews');
    if (!previewBox) {
      previewBox = document.createElement('div');
      previewBox.id = 'previews';
      imageInput.parentElement.appendChild(previewBox);
    }

    previewBox.innerHTML = '';

    const blob = URL.createObjectURL(file);
    const img = document.createElement('img');
    img.src = blob;
    img.alt = 'preview';
    img.className = 'preview-img';
    img.style.maxWidth = '200px';
    img.onload = () => URL.revokeObjectURL(blob); 

    previewBox.appendChild(img);
  });
};

document.addEventListener('turbo:load', initPreview);
document.addEventListener('DOMContentLoaded', initPreview);
