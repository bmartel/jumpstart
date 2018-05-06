import Vue from 'vue';
import Vuex from 'vuex';
import store, { hydrate } from '@/store';

describe('store', () => {
	it('should return a valid vuex store', () => {
		expect(store).toBeInstanceOf(Vuex.Store);
	});

	it('should use initial state when provided', () => {

		store.replaceState = jest.fn();
		hydrate(store, {});
		expect(store.replaceState).toHaveBeenCalledWith({});
	});

	it('should not use initial state when no data is provided', () => {
		jest.mock('@/store');

		store.replaceState = jest.fn();
		hydrate(store);
		expect(store.replaceState).toHaveBeenCalledTimes(0);
	});
});
