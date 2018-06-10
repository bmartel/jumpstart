import axios from 'axios';
import api from '@/endpoints';

export const namespaced = true;

export const initialState = () => ({
  user: {},
  masquerade: false,
});

const types = {};

export const state = initialState;

export const actions = {
  async logout() {
    try {
      await axios.delete(api.users.signout);
      window.location = '/';
    } catch (err) {
      console.log(err);
    }
  },
};

export const mutations = {};

export const getters = {
  loggedIn: state => !!state.user.id,
};
