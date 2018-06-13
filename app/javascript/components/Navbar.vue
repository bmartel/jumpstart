<template>
  <div class="py-2 sticky z-10 pin-t shadow">
    <div class="container px-2 md:px-0 mx-auto flex items-center justify-between">
      <div class="flex items-center">
        <slot name="brand"/>

        <slot name="actions-left"/>
      </div>

      <slot/>

      <div
        class="flex items-center">
        <slot name="actions-right"/>
        <dropdown-menu
          v-if="user.id"
          :items="items"
          menu-style="max-w-xs shadow rounded mt-2">
          <avatar
            :url="user.avatar"
          />
        </dropdown-menu>
        <div v-else>
          <a
            href="/users/sign_in"
            class="text-white">Sign in</a>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Avatar from '@/components/Avatar';
import DropdownMenu from '@/components/DropdownMenu';
import endpoint from '@/endpoints';

export default {
  components: {
    Avatar,
    DropdownMenu,
  },

  props: {
    user: {
      type: Object,
      default: () => ({}),
    },
  },

  data() {
    return {
      items: [
        { label: this.user.email },
        {
          text: 'Settings',
          prependIcon: 'settings',
          url: endpoint.users.edit,
        },
        { divider: true },
        {
          text: 'Logout',
          prependIcon: 'log-out',
          action: () => this.$store.dispatch('auth/logout'),
        },
      ],
    };
  },
};
</script>
