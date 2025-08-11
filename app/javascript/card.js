const pay = () => {
  const form = document.getElementById("charge-form");
  if (!form) return;

  if (form.dataset.payBound === "true") return;
  form.dataset.payBound = "true";

  if (typeof Payjp === "undefined" || !window.gon?.public_key) return;

  const payjp = Payjp(gon.public_key);
  const elements = payjp.elements();

  const mount = (selector, type) => {
    const host = document.querySelector(selector);
    if (!host) return null;
    host.innerHTML = "";
    const el = elements.create(type, { style: { base: { fontSize: "16px" } } });
    el.mount(selector);
    return el;
  };

  const numberElement = mount("#number-form", "cardNumber");
  const expiryElement = mount("#expiry-form", "cardExpiry");
  const cvcElement    = mount("#cvc-form",    "cardCvc");
  if (!numberElement || !expiryElement || !cvcElement) return;

  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const response = await payjp.createToken(numberElement);

    if (response.error) {
    
      form.submit();
      return;
    }

    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "token";
    input.value = response.id;
    form.appendChild(input);

    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();

    form.submit();
  });
};

window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);

