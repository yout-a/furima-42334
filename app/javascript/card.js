const pay = () => {
  const form = document.getElementById("charge-form");
  if (!form) return;

  const payjp = Payjp(gon.public_key);
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
        form.submit(); 
        return;
      }

      const token = response.id;
      document.getElementById("card-token").value = token;

      form.submit();
    });
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
