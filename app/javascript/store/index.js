import Vue from 'vue';
import Vuex from 'vuex';

import state from './state';
import actions from './actions';
import mutations from './mutations';
import getters from './getters';
import modules from './modules';
import plugins from './plugins';

Vue.use(Vuex);

export const hydrate = (store, data) => {
  if (data) {
    store.replaceState(data);
  }
}

export default new Vuex.Store({
  state,
  actions,
  mutations,
  getters,
  modules,
  plugins,
});
