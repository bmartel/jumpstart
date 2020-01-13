import * as Rails from '@rails/ujs';
// import * as ActiveStorage from '@rails/activestorage';
// import Turbolinks from 'turbolinks';
import Vue from 'vue';
// import TurbolinksAdapter from 'vue-turbolinks';
import "../utils/registerServiceWorker";
import store, { hydrate } from '@/store';
import '@/directives/action';
import App from '@/app';
import '@/styles/application.css';

Vue.config.productionTip = false;

// Hydrate store data from Rails
hydrate(store);

// Register any other modules

// Vue.use(TurbolinksAdapter);

// document.addEventListener('turbolinks:load', () => {
document.addEventListener('DOMContentLoaded', () => {
  new Vue({
    el: '#app',
    store,
    components: { App },
  });
});

// Start Rails Turbolinks and ActiveStorage
Rails.start();
// ActiveStorage.start();
// Turbolinks.start();
