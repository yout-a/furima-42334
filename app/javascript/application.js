import "@hotwired/turbo-rails"

document.addEventListener("turbo:load", () => {
  console.log("🚀 turbo:load 発火しました")

  const logoutLink = document.querySelector("a.logout")
  if (logoutLink) {
    console.log("✅ logoutリンク見つかりました:", logoutLink.outerHTML)
  } else {
    console.warn("❌ logoutリンク見つかりません")
  }
})
