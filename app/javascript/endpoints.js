export default {
  announcements: '/announcements',
  notifications: '/notifications',
  users: {
    signup: '/users/sign_up',
    signin: '/users/sign_in',
    signout: '/users/sign_out',
    password: '/users/password',
    cancel: '/users/cancel',
    confirmation: '/users/confirmation',
    unlock: '/users/unlock',
    invitation: '/users/invitation/new',
    edit: '/users/edit',
    masquerade: param => `/users/masquerade/${param}`,
  },
  storage: {
    uploads: '/rails/active_storage/direct_uploads',
  },
};
