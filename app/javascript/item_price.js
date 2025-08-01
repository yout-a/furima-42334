const price = () => {
  const priceInput = document.getElementById('item-price');
  const addTaxDom = document.getElementById('add-tax-price');
  const profitDom = document.getElementById('profit');

  if (!priceInput) return;

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
};

window.addEventListener('turbo:load', price);
window.addEventListener('turbo:render', price);


