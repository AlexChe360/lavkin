import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["address", "field"]

  connect() {
    this.toggle()
  }

  toggle() {
    const selected = this.element.querySelector(
      'input[name="checkout[fulfillment_type]"]:checked'
    )

    const deliverySelected = selected?.value === "delivery"

    if (this.hasAddressTarget) {
      this.addressTarget.classList.toggle(
        "hidden",
        !deliverySelected
      )
    }

    this.fieldTargets.forEach((field) => {
      field.disabled = !deliverySelected
    })
  }
}