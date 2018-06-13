<template>
  <ul class="list-reset bg-white">
    <li
      v-for="(item, index) in items"
      :key="index">

      <div
        v-if="item.divider"
        :class="divider" />
      <div
        v-else-if="item.disabled"
        :class="`${itemText} opacity-50 cursor-not-allowed ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          :class="iconPrependStyles" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          :class="iconAppendStyles" />
      </div>
      <div
        v-else-if="item.label"
        :class="`${itemText} font-semibold opacity-75 ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          :class="iconPrependStyles" />
        {{ item.label }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          :class="iconAppendStyles" />
      </div>
      <button
        v-else-if="item.action"
        :class="`${itemText} ${itemBackground} ${itemLayout}`"
        @click="item.action">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          :class="iconPrependStyles" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          :class="iconAppendStyles" />
      </button>
      <router-link
        v-else-if="item.route"
        :to="item.route"
        :class="`${itemText} ${itemBackground} ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          :class="iconPrependStyles" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          :class="iconAppendStyles" />
      </router-link>
      <a
        v-else-if="item.url"
        :href="item.url"
        :class="`${itemText} ${itemBackground} ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          :class="iconPrependStyles" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          :class="iconAppendStyles" />
      </a>
      <div
        v-else
        :class="`${itemText} ${itemBackground} ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          :class="iconPrependStyles" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          :class="iconAppendStyles" />
      </div>
    </li>
  </ul>
</template>

<script>
import FeatherIcon from '@/components/FeatherIcon';

export default {
  components: {
    FeatherIcon,
  },

  props: {
    items: {
      type: Array,
      default: () => [],
    },
    divider: {
      type: String,
      default: 'border-t',
    },
    iconAppendStyles: {
      type: String,
      default: 'ml-2',
    },
    iconPrependStyles: {
      type: String,
      default: 'mr-2',
    },
    itemText: {
      type: String,
      default: 'no-underline text-grey-dark text-sm',
    },
    itemBackground: {
      type: String,
      default: 'transition hover:bg-grey-lighter cursor-pointer',
    },
    itemLayout: {
      type: String,
      default: 'w-full flex items-center p-3',
    },
  },
};
</script>
