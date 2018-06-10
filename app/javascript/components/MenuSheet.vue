<template>
  <ul class="list-reset py-2">
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
          class="mr-1" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          class="ml-1" />
      </div>
      <div
        v-else-if="item.label"
        :class="`${itemText} font-semibold opacity-75 ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          class="mr-1" />
        {{ item.label }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          class="ml-1" />
      </div>
      <button
        v-else-if="item.action"
        :class="`${itemText} ${itemBackground} ${itemLayout}`"
        @click="item.action">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          class="mr-1" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          class="ml-1" />
      </button>
      <a
        v-else-if="item.url"
        :href="item.url"
        :class="`${itemText} ${itemBackground} ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          class="mr-1" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          class="ml-1" />
      </a>
      <div
        v-else
        :class="`${itemText} ${itemBackground} ${itemLayout}`">
        <feather-icon
          v-if="item.prependIcon"
          :name="item.prependIcon"
          class="mr-1" />
        {{ item.text }}
        <feather-icon
          v-if="item.appendIcon"
          :name="item.appendIcon"
          class="ml-1" />
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
    itemText: {
      type: String,
      default: 'text-grey-dark text-sm',
    },
    itemBackground: {
      type: String,
      default: 'hover:bg-grey-lighter cursor-pointer',
    },
    itemLayout: {
      type: String,
      default: 'w-full flex items-center p-3',
    },
  },
};
</script>
