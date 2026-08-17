import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = [
    "dialog",
    "title",
    "message",
    "confirmButton"
  ]

  connect() {
    this.pendingElement = null
  }

  open(event) {
    event.preventDefault()

    const element = event.currentTarget

    this.pendingElement = element

    this.titleTarget.textContent =
      element.dataset.confirmTitle ||
      "Подтвердите действие"

    this.messageTarget.textContent =
      element.dataset.confirmMessage ||
      "Вы уверены?"

    this.confirmButtonTarget.textContent =
      element.dataset.confirmText ||
      "Подтвердить"

    const danger =
      element.dataset.confirmDanger === "true"

    this.confirmButtonTarget.className =
      danger
        ? "inline-flex h-10 items-center justify-center rounded-xl bg-red-600 px-4 text-sm font-black text-white hover:bg-red-700"
        : "inline-flex h-10 items-center justify-center rounded-xl bg-[#303030] px-4 text-sm font-black text-white hover:bg-black"

    this.dialogTarget.showModal()
  }

  close() {
    this.pendingElement = null
    this.dialogTarget.close()
  }

  confirm() {
    const element = this.pendingElement

    if (!element) return

    const form =
      element.closest("form")

    this.pendingElement = null
    this.dialogTarget.close()

    if (form) {
      form.requestSubmit()
    }
  }

  backdrop(event) {
    if (event.target === this.dialogTarget) {
      this.close()
    }
  }
}