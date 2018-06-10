<template>
  <svg
    :width="size"
    :height="size"
    class="icon"
  >
    <use :xlink:href="sprite"/>
  </svg>
</template>

<script>
import FeatherSprite from 'feather-icons/dist/feather-sprite.svg';

export default {
  props: {
    name: {
      type: String,
      required: true,
    },
    size: {
      type: Number,
      default: 18,
    },
  },
  computed: {
    sprite() {
      return `${FeatherSprite}#${this.name}`;
    },
  },
};
</script>

<style>
.icon {
  stroke: currentColor;
  stroke-width: 2;
  stroke-linecap: round;
  stroke-linejoin: round;
  fill: none;
}
</style>
