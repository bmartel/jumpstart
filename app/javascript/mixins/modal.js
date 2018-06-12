export default {
  props: {
    value: {
      type: Boolean,
      default: false,
    },
  },

  data() {
    return {
      active: this.value,
    };
  },

  methods: {
    toggleModal(e) {
      e.stopPropagation();
      this.state = !this.state;
    },
    documentClick(e) {
      const el = this.$refs.modalTarget;
      const target = e.target;

      if (el !== target && !el.contains(target)) {
        this.state = false;
      }
    },
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

  created() {
    document.addEventListener('click', this.documentClick);
  },

  destroyed() {
    document.removeEventListener('click', this.documentClick);
  },
};
