import "@hotwired/turbo-rails"

document.addEventListener('turbo:load', () => {
  const priceInput = document.getElementById('item-price');
  const addTaxDom = document.getElementById('add-tax-price');
  const profitDom = document.getElementById('profit');

  if (!priceInput) return;  // DOMが存在しないページでは動作しないように

  priceInput.addEventListener('input', () => {
    const inputValue = priceInput.value;

    if (!inputValue || isNaN(inputValue)) {
      addTaxDom.innerHTML = '';
      profitDom.innerHTML = '';
      return;
    }

    const price = parseInt(inputValue, 10);
    const fee = Math.floor(price * 0.1);
    const profit = price - fee;

    addTaxDom.innerHTML = fee.toLocaleString();
    profitDom.innerHTML = profit.toLocaleString();
  });
});
