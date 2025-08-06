const pay = () => {
  const form = document.getElementById("charge-form");
  if (!form) return;

  const payjp = Payjp("pk_test_781ea1564cf96462a5751349");
  const elements = payjp.elements();
  const numberElement = elements.create("cardNumber");
  const expiryElement = elements.create("cardExpiry");
  const cvcElement = elements.create("cardCvc");

  numberElement.mount("#number-form");
  expiryElement.mount("#expiry-form");
  cvcElement.mount("#cvc-form");

  form.addEventListener("submit", (e) => {
    e.preventDefault();
    payjp.createToken(numberElement).then((response) => {
      if (response.error) {
        return;
      }

      const token = response.id;
      const tokenInput = document.createElement("input");
      tokenInput.setAttribute("type", "hidden");
      tokenInput.setAttribute("name", "token");
      tokenInput.setAttribute("value", token);
      form.appendChild(tokenInput);

      numberElement.clear();
      expiryElement.clear();
      cvcElement.clear();

      form.submit();
    });
  });
};

window.addEventListener("turbo:load", pay);
