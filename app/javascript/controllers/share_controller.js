import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = { text: String }

  copy() {
    if (navigator.clipboard) {
      navigator.clipboard.writeText(this.textValue).then(() => {
        const original = this.element.textContent
        this.element.textContent = "✅ Copiado!"
        setTimeout(() => { this.element.textContent = original }, 2000)
      })
    } else {
      // Fallback for older browsers
      const textarea = document.createElement("textarea")
      textarea.value = this.textValue
      document.body.appendChild(textarea)
      textarea.select()
      document.execCommand("copy")
      document.body.removeChild(textarea)
      const original = this.element.textContent
      this.element.textContent = "✅ Copiado!"
      setTimeout(() => { this.element.textContent = original }, 2000)
    }
  }
}
