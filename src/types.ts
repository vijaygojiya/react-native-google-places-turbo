export type LatLng = {
  latitude: number;
  longitude: number;
};

export interface AutocompleteOptions {
  countries?: string[];
}

export type Place = {
  name: string;
  placeID: string;
  coordinate: LatLng;
  address: string;
};
