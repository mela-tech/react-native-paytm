import { NativeModules, NativeEventEmitter, DeviceEmitter } from 'react-native';

const Events = {
  PAYTM_RESPONSE: 'PayTMResponse'
};
const EventEmitter = NativeModules.RNPayTm ? new NativeEventEmitter(NativeModules.RNPayTm) : DeviceEmitter;

function startPayment(details) {
  NativeModules.RNPayTm.startPayment(details);
}

function addListener(eventName, handler) {
  if (EventEmitter) {
    EventEmitter.addListener(eventName, handler);
  }
}

function removeListener(eventName, handler) {
  if (EventEmitter) {
    EventEmitter.removeListener(eventName, handler);
  }
}

export default {
  Events,
  addListener,
  removeListener,
  startPayment
};
