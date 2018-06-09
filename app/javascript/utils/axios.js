import axios from 'axios';

/**
 * Set Global defaults
 */
export const setDefault = (key, value) => {
  axios.defaults[key] = value;
};

/**
 * Set Global headers config
 */
export const headers = (key, value, valueKey) => {
  // If there is no value, just skip
  if (!value || (typeof valueKey !== 'undefined' && !value[valueKey])) {
    return;
  }

  let header = value;
  // Allow passing in an object with a value key to safely
  // extract the data
  if (valueKey) {
    header = value[valueKey];
  }

  // Ex. axios.defaults.headers.common['Authorization'] = AUTH_TOKEN;
  axios.defaults.headers.common[key] = header;
};

/**
 * Set current request csrf token
 */
export const setCsrfToken = token => {
  if (typeof token !== 'string') {
    headers('X-CSRF-TOKEN', token, 'csrfToken');
  } else {
    headers('X-CSRF-TOKEN', token);
  }
};

/**
 * Form encoded request handling
 */
export const form = (url, data, axiosInstance) => {
  const instance = axiosInstance || axios;
  const defaultHeaders = {};
  defaultHeaders['Content-Type'] = 'application/x-www-form-urlencoded; charset=UTF-8';

  const params = new URLSearchParams();
  Object.keys(data).map(key => params.append(key, data[key]));

  return (config = {}) => {
    config.headers = { ...defaultHeaders, ...(config.headers || {}) };
    return instance({ method: 'post', url, params, ...config });
  };
};

/**
 * Default axios request interceptor
 */
export const requestInterceptor = {
  res: res => {
    // A before middleware to preprocess all incoming requests

    if (res.data) {
      if (res.data.location) {
        return (window.location = res.data.location);
      }
      if (res.data.redirect) {
        return (window.location = res.data.redirect);
      }

      // Refresh the csrfToken between requests
      setCsrfToken(res.data);
    }

    return res;
  },
  err: err => {
    // Global error handler

    // If there is an err which responds with a data body containing a location
    // or redirect key, redirect the browser
    const res = err.response;

    if (res && res.data) {
      if (res.data.location) {
        return (window.location = res.data.location);
      }
      if (res.data.redirect) {
        return (window.location = res.data.redirect);
      }
      return Promise.reject(err);
    } else {
      return Promise.reject({ errors: [err.message] });
    }
  },
};

// set axios defaults
axios.interceptors.response.use(requestInterceptor.res, requestInterceptor.err);
setDefault('withCredentials', true);
headers('Content-Type', 'application/json');
headers('X-Requested-With', 'XMLHttpRequest');

export default axios;
