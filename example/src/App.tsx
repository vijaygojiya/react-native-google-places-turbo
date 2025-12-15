import { View, StyleSheet, Button } from 'react-native';
import {
  initialize,
  openAutocompleteModal,
} from 'react-native-google-places-turbo';
import { useCallback } from 'react';

initialize('', console.log, console.log);

export default function App() {
  //

  const openGooglePlaceMoalal = useCallback(async () => {
    try {
      const place = await openAutocompleteModal({
        countries: ['IN'],
      });
      console.log('[Place]:', place);
    } catch (error) {
      console.log('error while opening auto complte modal', error);
    }
  }, []);

  return (
    <View style={styles.container}>
      <Button onPress={openGooglePlaceMoalal} title="Open Modal" />
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
  },
});
