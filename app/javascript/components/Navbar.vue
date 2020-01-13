<template>
  <div class="navbar flex items-center sticky z-10 top-0 shadow">
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
        <div
          v-else
          class="flex items-center">
          <div
            :class="{'border-white': currentUrl(signinUrl)}"
            class="mr-6 py-1 border-transparent border-b-2 hover:border-white transition inline-flex items-center">
            <a
              :href="signinUrl"
              class="text-white no-underline font-thin inline-flex items-center">
              <span class="hidden md:inline-flex">Sign in</span>
              <feather-icon
                :size="20"
                class="md:hidden"
                name="log-in" />
            </a>
          </div>

          <div
            :class="{'md:bg-transparent': !currentUrl(signupUrl), 'bg-white': currentUrl(signupUrl) }"
            class="group p-1 md:py-1 md:px-2 rounded border-2 border-white hover:bg-white transition inline-flex items-center">
            <a
              :class="{'text-white': !currentUrl(signupUrl), 'text-primary': currentUrl(signupUrl)}"
              :href="signupUrl"
              class="group-hover:text-primary no-underline font-thin inline-flex items-center">
              <span class="hidden md:inline-flex">Sign up</span>
              <feather-icon
                :size="20"
                class="md:hidden"
                name="user" />
            </a>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import Avatar from '@/components/Avatar';
import DropdownMenu from '@/components/DropdownMenu';
import endpoint from '@/endpoints';
import FeatherIcon from '@/components/FeatherIcon';
import { currentUrl } from '@/utils/route';

export default {
  components: {
    Avatar,
    DropdownMenu,
    FeatherIcon,
  },

  props: {
    user: {
      type: Object,
      default: () => ({}),
    },
  },

  data() {
    return {
      signinUrl: endpoint.users.signin,
      signupUrl: endpoint.users.signup,
      items: [
        { label: this.user.email },
        {
          text: 'Invite',
          prependIcon: 'user-plus',
          url: endpoint.users.invitation,
        },
        {
          text: 'Settings',
          prependIcon: 'settings',
          url: endpoint.users.edit,
        },
        {
          text: 'Admin',
          prependIcon: 'lock',
          url: endpoint.admin,
          skip: this.user.admin !== true,
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

  methods: { currentUrl },
};
</script>
