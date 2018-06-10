<template>
  <div class="flex flex-col">
    <div 
      class="cursor-pointer"
      @click.prevent="toggle">
      <slot />
    </div>
    <div class="relative">
      <menu-sheet
        v-if="state"
        :items="items"
        :class="`absolute ${position} ${menuStyle}`" />
    </div>
  </div>
</template>

<script>
import MenuSheet from '@/components/MenuSheet';

export default {
  components: {
    MenuSheet,
  },
  props: {
    value: {
      type: Boolean,
      default: false,
    },
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
  data() {
    return {
      active: this.value,
    };
  },
  computed: {
    state: {
      get() {
        return this.active;
      },
      set(val) {
        this.active = val;
        this.$emit('input', val);
      },
    },
  },
  methods: {
    toggle() {
      this.state = !this.state;
    },
  },
};
</script>
