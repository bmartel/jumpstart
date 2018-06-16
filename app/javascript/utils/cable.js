import ActionCable from 'actioncable';

let consumer;

const channel = (...args) => {
  if (!consumer) {
    consumer = ActionCable.createConsumer();
  }

  return consumer.subscriptions.create(...args);
};

export default channel;
