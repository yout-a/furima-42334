const pay = () => {
  const form = document.getElementById("charge-form");
  if (!form) return;

  // Turbo の重複バインド対策
  if (form.dataset.payBound === "true") return;
  form.dataset.payBound = "true";

  // pay.js の読み込み確認
  if (typeof Payjp === "undefined") {
    console.warn("Payjp not found: https://js.pay.jp/v2/pay.js が読み込まれていません");
    return;
  }

  // 公開鍵を gon か meta から取得（どちらかでOK）
  const meta = document.querySelector('meta[name="payjp-public-key"]');
  const publicKey = meta?.content || window.gon?.public_key;
  if (!publicKey) {
    console.warn("PAYJP_PUBLIC_KEY が見つかりません（gon か meta で渡してください）");
    return;
  }

  const payjp = Payjp(publicKey);
  const elements = payjp.elements();

  const mount = (selector, type) => {
    const host = document.querySelector(selector);
    if (!host) return null;
    host.innerHTML = ""; // Turbo で戻ってきた時の重複防止
    const el = elements.create(type, { style: { base: { fontSize: "16px" } } });
    el.mount(selector);
    return el;
  };

  // ページ側の id 名に合わせてください（例：#number-form / #expiry-form / #cvc-form）
  const numberElement = mount("#number-form", "cardNumber");
  const expiryElement = mount("#expiry-form", "cardExpiry");
  const cvcElement    = mount("#cvc-form",    "cardCvc");
  if (!numberElement || !expiryElement || !cvcElement) return;

  form.addEventListener("submit", async (e) => {
    e.preventDefault();

    const { token, error } = await payjp.createToken(numberElement);

    if (error) {
      // ここで submit はせず、エラーメッセージを出す
      alert(error.message || "カード情報を確認してください。");
      return;
    }

    // hidden でトークンを付与
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = "token";
    input.value = token.id;
    form.appendChild(input);

    // 送信前に Elements 側の表示はクリア（name の付いた生カード項目を送らない）
    numberElement.clear();
    expiryElement.clear();
    cvcElement.clear();

    form.submit();
  });
};

// Turbo の画面遷移に追従
window.addEventListener("turbo:load", pay);
window.addEventListener("turbo:render", pay);
