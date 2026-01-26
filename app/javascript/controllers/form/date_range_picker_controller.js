import { Controller } from "@hotwired/stimulus";
import flatpickr from "flatpickr";
import { Portuguese } from "flatpickr/dist/l10n/pt";
import { Spanish } from "flatpickr/dist/l10n/es";
import "flatpickr/dist/flatpickr.css";
import { getBrowserLocale, getUserLocale } from "../../utils/locale";

export default class extends Controller {
  static targets = ["dateRangeForm"];

  connect() {
    const locale = this.getLocaleConfig();

    this.flatpickr = flatpickr(this.dateRangeFormTarget, {
      mode: "range",
      dateFormat: "Y/m/d",
      locale: {
        ...locale,
        rangeSeparator: " - ",
      },
      showMonths: 2,
      allowInput: false,
      clickOpens: true,
      position: "below left",
      onClose: (selectedDates) => {
        if (selectedDates.length === 2) {
          this.ensureTwoDatesInInput(selectedDates);
          this.element.requestSubmit();
        }
      },
    });

    this.addQuickSelectButtons();
  }

  disconnect() {
    if (this.flatpickr) {
      this.flatpickr.destroy();
    }
  }

  addQuickSelectButtons() {
    const container = document.createElement("div");
    container.className =
      "flatpickr-quick-select flex flex-wrap gap-1 p-2 border-t border-light-palette-p2 bg-light-palette-p4";

    const ranges = this.getPresetRanges();

    ranges.forEach(({ label, dates }) => {
      const btn = document.createElement("button");
      btn.type = "button";
      btn.className =
        "text-xs px-2 py-1 rounded bg-light-palette-p3 hover:bg-brand-palette-07 text-dark-gray-palette-p3 hover:text-brand-palette-03 transition-colors";
      btn.textContent = label;
      btn.addEventListener("click", (e) => {
        e.preventDefault();
        e.stopPropagation();
        this.flatpickr.setDate(dates, true);
        this.ensureTwoDatesInInput(dates);
        this.flatpickr.close();
        this.element.requestSubmit();
      });
      container.appendChild(btn);
    });

    setTimeout(() => {
      const calendarContainer = this.flatpickr.calendarContainer;
      if (calendarContainer) {
        calendarContainer.appendChild(container);
      }
    }, 0);
  }

  ensureTwoDatesInInput(dates) {
    if (dates.length === 2) {
      const formatDate = (date) => {
        const year = date.getFullYear();
        const month = String(date.getMonth() + 1).padStart(2, "0");
        const day = String(date.getDate()).padStart(2, "0");
        return `${year}/${month}/${day}`;
      };
      const formattedValue = `${formatDate(dates[0])} - ${formatDate(dates[1])}`;
      this.dateRangeFormTarget.value = formattedValue;
    }
  }

  getPresetRanges() {
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    const yesterday = new Date(today);
    yesterday.setDate(yesterday.getDate() - 1);

    const last7Days = new Date(today);
    last7Days.setDate(last7Days.getDate() - 6);

    const last30Days = new Date(today);
    last30Days.setDate(last30Days.getDate() - 29);

    const startOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
    const endOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

    const startOfLastMonth = new Date(
      today.getFullYear(),
      today.getMonth() - 1,
      1,
    );
    const endOfLastMonth = new Date(today.getFullYear(), today.getMonth(), 0);

    const labels = this.getLocalizedLabels();

    return [
      { label: labels.today, dates: [today, today] },
      { label: labels.yesterday, dates: [yesterday, yesterday] },
      { label: labels.last7Days, dates: [last7Days, today] },
      { label: labels.last30Days, dates: [last30Days, today] },
      { label: labels.thisMonth, dates: [startOfMonth, endOfMonth] },
      { label: labels.lastMonth, dates: [startOfLastMonth, endOfLastMonth] },
    ];
  }

  getLocalizedLabels() {
    const locale = this.locale;

    if (locale === "pt-br") {
      return {
        today: "Hoje",
        yesterday: "Ontem",
        last7Days: "Últimos 7 dias",
        last30Days: "Últimos 30 dias",
        thisMonth: "Este mês",
        lastMonth: "Mês passado",
      };
    } else if (locale === "es") {
      return {
        today: "Hoy",
        yesterday: "Ayer",
        last7Days: "Últimos 7 días",
        last30Days: "Últimos 30 días",
        thisMonth: "Este mes",
        lastMonth: "Mes pasado",
      };
    }

    return {
      today: "Today",
      yesterday: "Yesterday",
      last7Days: "Last 7 Days",
      last30Days: "Last 30 Days",
      thisMonth: "This Month",
      lastMonth: "Last Month",
    };
  }

  getLocaleConfig() {
    const locale = this.locale;

    if (locale === "pt-br") {
      return Portuguese;
    } else if (locale === "es") {
      return Spanish;
    }

    return "default";
  }

  get locale() {
    return (
      getUserLocale().trim() !== "" ? getUserLocale() : getBrowserLocale()
    )
      .toLowerCase()
      .replace("_", "-");
  }
}
