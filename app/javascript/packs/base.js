import Rails from 'rails-ujs';
// import Turbolinks from 'turbolinks';
// import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue';
import '@/directives/action';
import store, { hydrate } from '@/store';
import App from '@/app';

Vue.config.productionTip = false;

// Hydrate store data from Rails
hydrate(store, window.__INITIAL_STATE__);

// Register any other modules

// Vue.use(TurbolinksAdapter);

// document.addEventListener('turbolinks:load', () => {
document.addEventListener('DOMContentLoaded', () => {
  const app = new Vue({
    el: '#app',
    store,
    components: { App },
  });
});

// Start Rails Turbolinks
Rails.start();
// Turbolinks.start();
