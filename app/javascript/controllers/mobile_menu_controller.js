import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["menu", "overlay"]

  connect() {
    this.boundClose = this.close.bind(this)

    document.addEventListener(
      "turbo:before-visit",
      this.boundClose
    )
  }

  disconnect() {
    document.removeEventListener(
      "turbo:before-visit",
      this.boundClose
    )
  }

  open() {
    this.menuTarget.classList.remove("-translate-x-full")
    this.overlayTarget.classList.remove("hidden")

    document.body.classList.add("overflow-hidden")
  }

  close() {
    this.menuTarget.classList.add("-translate-x-full")
    this.overlayTarget.classList.add("hidden")

    document.body.classList.remove("overflow-hidden")
  }
}