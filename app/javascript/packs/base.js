import 'babel-polyfill';

import Rails from 'rails-ujs';
import Turbolinks from 'turbolinks';
import TurbolinksAdapter from 'vue-turbolinks';
import Vue from 'vue';
import Vuex from 'vuex';
import store, { hydrate } from '@/store';
import App from '@/app';

// Register any other modules

Vue.use(TurbolinksAdapter);

document.addEventListener('turbolinks:load', () => {
  const app = new Vue({
    el: '#app',
    store,
    components: { App },
  });
});

// Start Rails Turbolinks
Rails.start();
Turbolinks.start();
