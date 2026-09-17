import { Controller, Application } from "@hotwired/stimulus"
import Notification from "stimulus-notification"

// Connects to data-controller="notification"
export default class extends Notification {
  static values = { duration: Number }

  connect() {
    super.connect()
    this.remaining = this.durationValue || 5000
    this.arm()
    this.element.addEventListener("mouseenter", () => this.pause())
    this.element.addEventListener("mouseleave", () => this.resume())
    this.element.addEventListener("click", (e) => this.togglePin(e))
  }

  arm() {
    this.start = Date.now()
    this.timeout = setTimeout(() => this.hide(), this.remaining)
    this.element.style.setProperty("--duration", `${this.remaining}ms`)
    this.element.classList.remove("paused")
  }

  pause() {
    if (this.pinned) return
    clearTimeout(this.timeout)
    this.remaining -= Date.now() - this.start
    this.element.classList.add("paused")
  }

  resume() {
    if (this.pinned || this.remaining <= 0) return
    this.arm()
  }

  togglePin(e) {
    if (e.target.closest("[data-action*='hide']")) return
    this.pinned = !this.pinned
    this.pinned ? this.pause() : this.resume()
  }
}