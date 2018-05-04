import Vue from 'vue';
import Vuex from 'vuex';

Vue.use(Vuex);

export const hydrate = (store, data) => {
  if (data) {
    store.replaceState(data);
  }
}
