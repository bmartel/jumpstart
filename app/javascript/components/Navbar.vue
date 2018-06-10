<template>
  <div class="py-2 sticky pin-t shadow-lg">
    <div class="container px-2 md:px-0 mx-auto flex items-center justify-between">
      <div class="flex items-center">
        <slot name="brand"/>

        <slot name="actions-left"/>
      </div>

      <slot/>

      <div
        v-if="user.id"
        class="flex items-center">
        <slot name="actions-right"/>
        <avatar :url="user.avatar" />
      </div>
      <div v-else>
        <a 
          href="/users/sign_in" 
          class="text-white">Sign in</a>
      </div>
    </div>
  </div>
</template>

<script>
import Avatar from '@/components/Avatar';

export default {
  components: {
    Avatar,
  },

  props: {
    user: {
      type: Object,
      default: () => ({}),
    },
  },
};
</script>
