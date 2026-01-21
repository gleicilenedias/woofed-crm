// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import jquery from "jquery";
window.jQuery = jquery;
window.$ = jquery;
import Rails from "@rails/ujs";
import "@hotwired/turbo-rails";
import * as ActiveStorage from "@rails/activestorage";
import "../channels";
import "../controllers";
import lucide from "lucide/dist/umd/lucide";
import { setBrowserTimezoneCookie } from "../utils/set_browser_timezone_cookie";

Rails.start();
ActiveStorage.start();
import "trix";
import "@rails/actiontext";
// import "@nathanvda/cocoon";
import "flowbite/dist/flowbite.turbo.js";

$(document).on("turbo:load", () => {
  initLibraries();
});
//

// $(document).on("turbo:frame-load", function (e) {
//   lucide.createIcons();
//   initDismisses();
//   initDropdowns();
// })

$(document).on("turbo:render", function (e) {
  initLibraries();
});

$(document).on("turbo:frame-render", function (e) {
  initLibraries();
});

// addEventListener("turbo:before-stream-render", (event) => {
//   const originalRender = event.detail.render;

//   event.detail.render = function (streamElement) {
//     originalRender(streamElement);
//     initLibraries();
//   };
// });

function initLibraries() {
  initFlowbite();
  lucide.createIcons();
  // Daterangepicker
  if (jQuery().daterangepicker) {
    if ($(".datetimepicker").length) {
      $(".datetimepicker").daterangepicker({
        locale: { format: "YYYY-MM-DD HH:mm" },
        singleDatePicker: true,
        timePicker: true,
        timePicker24Hour: true,
      });
    }
  }
}

setBrowserTimezoneCookie();

// To see this message, add the following to the `<head>` section in your
// views/layouts/application.html.erb
//
//    <%= vite_client_tag %>
//    <%= vite_javascript_tag 'application' %>
console.log("Vite ⚡️ Rails");

// If using a TypeScript entrypoint file:
//     <%= vite_typescript_tag 'application' %>
//
// If you want to use .jsx or .tsx, add the extension:
//     <%= vite_javascript_tag 'application.jsx' %>

console.log(
  "Visit the guide for more information: ",
  "https://vite-ruby.netlify.app/guide/rails",
);

// Example: Load Rails libraries in Vite.
//
// import * as Turbo from '@hotwired/turbo'
// Turbo.start()
//
// import ActiveStorage from '@rails/activestorage'
// ActiveStorage.start()
//
// // Import all channels.
// const channels = import.meta.glob('./**/*_channel.js', { eager: true })

// Example: Import a stylesheet in app/frontend/index.css
// import '~/index.css'
