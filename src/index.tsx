import GooglePlacesTurbo from './NativeGooglePlacesTurbo';
import type { AutocompleteOptions } from './types';

const noop = () => {};

/**
 * Initialize the Google Places SDK with your API Key.
 * @param key Your Google Places API Key
 * @param onSuccess Callback for successful initialization
 * @param onError Callback for initialization error
 */
export function initialize(
  key: string,
  onSuccess: (r: string) => void = noop,
  onError: (e: string) => void = noop
) {
  return GooglePlacesTurbo.initialize(key, onSuccess, onError);
}

/**
 * Open the Google Places Autocomplete Modal.
 * @param options Configuration options for the autocomplete modal (e.g., country filter)
 */
export function openAutocompleteModal(options: AutocompleteOptions = {}) {
  return GooglePlacesTurbo.openAutocompleteModal(options);
}
