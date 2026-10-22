import { Controller } from "@hotwired/stimulus"

// Живое превью адреса витрины. Транслитерация совпадает с Slugifier на сервере.
const MAP = {
  а: "a", б: "b", в: "v", г: "g", д: "d", е: "e", ё: "yo", ж: "zh", з: "z",
  и: "i", й: "y", к: "k", л: "l", м: "m", н: "n", о: "o", п: "p", р: "r",
  с: "s", т: "t", у: "u", ф: "f", х: "kh", ц: "ts", ч: "ch", ш: "sh",
  щ: "shch", ъ: "", ы: "y", ь: "", э: "e", ю: "yu", я: "ya",
  ә: "a", ғ: "g", қ: "k", ң: "n", ө: "o", ұ: "u", ү: "u", һ: "h", і: "i"
}

export default class extends Controller {
  static targets = ["name", "slug", "preview"]
  static values = { placeholder: { type: String, default: "coffee-time" } }

  connect() {
    this.update()
  }

  update() {
    const source = this.slugTarget.value.trim() || this.nameTarget.value
    this.previewTarget.textContent = this.slugify(source) || this.placeholderValue
  }

  slugify(text) {
    return text
      .toLowerCase()
      .replace(/[а-яёәғқңөұүһі]/g, (char) => MAP[char] ?? "")
      .normalize("NFKD")
      .replace(/[̀-ͯ]/g, "")
      .replace(/[^a-z0-9]+/g, "-")
      .replace(/^-+|-+$/g, "")
  }
}