import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["sunIcon", "moonIcon"];

  connect() {
    this.updateIconVisibility();
  }

  toggle() {
    const isDark = document.documentElement.classList.contains('dark');
    const newTheme = isDark ? 'light' : 'dark';

    if (newTheme === 'dark') {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
    localStorage.setItem('theme', newTheme);
    this.updateIconVisibility();
  }

  updateIconVisibility() {
    const isDark = document.documentElement.classList.contains('dark');
    if (isDark) {
      this.moonIconTarget.classList.remove('hidden');
      this.sunIconTarget.classList.add('hidden');
    } else {
      this.sunIconTarget.classList.remove('hidden');
      this.moonIconTarget.classList.add('hidden');
    }
  }
}