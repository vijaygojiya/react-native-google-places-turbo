import { TurboModuleRegistry, type TurboModule } from 'react-native';
import type { Place } from './types';

export interface Spec extends TurboModule {
  //Warnign: type Object is unsafe
  openAutocompleteModal(options: Object): Promise<Place>;
  initialize(
    key: string,
    onSuccess: (r: string) => void,
    onError: (e: string) => void
  ): void;
}

export default TurboModuleRegistry.getEnforcing<Spec>('GooglePlacesTurbo');
