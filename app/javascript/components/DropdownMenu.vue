<template>
  <div class="flex flex-col">
    <div
      class="cursor-pointer flex items-center"
      @click="toggleModal">
      <slot />
    </div>
    <div
      ref="modalTarget"
      class="relative mt-px">
      <menu-sheet
        v-if="state"
        :items="items"
        :class="`absolute ${position} ${menuStyle}`" />
    </div>
  </div>
</template>

<script>
import Modal from '@/mixins/modal';

import MenuSheet from '@/components/MenuSheet';

export default {
  components: {
    MenuSheet,
  },
  mixins: [Modal],
  props: {
    items: {
      type: Array,
      default: () => [],
    },
    position: {
      type: String,
      default: 'pin-t pin-r',
    },
    menuStyle: {
      type: String,
      default: '',
    },
  },
};
</script>
