export const namespaced = true;

export const initialState = () => ({
  messages: [],
});

const types = {
  DISMISS: 'DISMISS',
};

export const state = initialState;

export const actions = {
  dismiss({ commit }, index) {
    commit(types.DISMISS, index);
  },
};

export const mutations = {
  [types.DISMISS](state, index) {
    state.messages.splice(index, 1);
  },
};

export const getters = {
  hasAlerts: state => state.messages.length > 0,
};
