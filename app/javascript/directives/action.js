import Vue from 'vue';
import axios from 'axios';

const fire = (action, method = 'GET') => {
  let url;
  let data = {};

  if (typeof action === 'string') {
    url = action;
  } else {
    url = action.url;
    data = action.data || {};
  }

  axios({
    method,
    url,
    data,
  })
    .then(res => {
      if (action.after) {
        action.after(res);
        return null;
      }

      return res;
    })
    .then(res => {
      if (!res) return;

      if (action.redirect) {
        redirect(action.redirect);
      }
    });
};

const confirm = (message, fireAction) => {
  if (window.confirm(message)) {
    fireAction();
  }
};

const redirect = url => {
  window.location = url;
};

Vue.directive('action', {
  bind(el, binding, vnode) {
    const { value, expression, modifiers, arg } = binding;

    if (modifiers.confirm) {
      el.addEventListener('click', confirm.bind(null, value.message, fire.bind(null, value, arg)));
    } else {
      el.addEventListener('click', fire.bind(null, value, arg));
    }
  },

  unbind(el, binding, vnode) {
    const { name, value, expression, modifiers, arg } = binding;

    if (modifiers.confirm) {
      el.removeEventListener('click', confirm.bind(null, value.message, fire.bind(null, value, arg)));
    } else {
      el.removeEventListener('click', fire.bind(null, value, arg));
    }
  },
});
