import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.format()
  }

  format() {
    let digits = this.element.value.replace(/\D/g, "")

    // 8XXXXXXXXXX -> 7XXXXXXXXXX
    if (digits.startsWith("8")) {
      digits = "7" + digits.slice(1)
    }

    // Номер всегда начинается с 7
    if (!digits.startsWith("7")) {
      digits = "7" + digits
    }

    digits = digits.slice(0, 11)

    const code = digits.slice(1, 4)
    const first = digits.slice(4, 7)
    const second = digits.slice(7, 9)
    const third = digits.slice(9, 11)

    let value = "+7"

    if (code) value += ` (${code}`
    if (code.length === 3) value += ")"
    if (first) value += ` ${first}`
    if (second) value += `-${second}`
    if (third) value += `-${third}`

    this.element.value = value
  }
}