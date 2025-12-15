# React Native Google Places Autocomplete (Native, TurboModule)

**react-native-google-places-turbo** is a high-performance React Native Google Places Autocomplete library built using the official Google Places SDK for Android (Kotlin) and iOS (Swift).

It is designed for the **React Native New Architecture** and powered by **TurboModules**, providing native UI, fast performance, and a bridge-free experience.

Unlike JavaScript-based wrappers, this library directly uses Google’s native autocomplete UI for the most accurate and reliable place search results.

---

## WHY react-native-google-places-turbo?

- ✅ **Built with React Native New Architecture**
- ✅ **Uses TurboModules (no legacy bridge)**
- ✅ **Official Google Places SDK**
- ✅ **Native autocomplete UI on Android and iOS**
- ✅ **Written in Swift and Kotlin**
- ✅ **Lightweight with minimal JavaScript layer**
- ✅ **Ideal replacement for older Google Places libraries**

If you are looking for a modern React Native Google Places Autocomplete library, this package is built for you.

---

## FEATURES

- 🚀 **Native performance** using official SDKs
- ⚡ **TurboModule support** for faster execution
- 📱 **Native Google autocomplete UI**
- 📍 **Accurate place search results**
- 🌍 **Country-based filtering support**
- 🛠 **Simple and clean JavaScript API**
- 🔐 **Secure API key handling**

## Demo

| Android                                                 | iOS                                                     |
| ------------------------------------------------------- | ------------------------------------------------------- |
| <img src="/assets/android-auto-complete.gif" width="250" /> | <img src="/assets/ios-auto-complete.gif" width="250" /> |

## INSTALLATION

Using npm:

```sh
npm install react-native-google-places-turbo
```

Using yarn:

```sh
yarn add react-native-google-places-turbo
```

### iOS Setup

Run pod install to install the native GoogleMaps/GooglePlaces dependencies:

```sh
cd ios && pod install
```

### Android Setup

No additional manual setup is usually required for Android as dependencies are automatically handled by Gradle.

## Google Cloud Setup

1. Go to the [Google Cloud Console](https://console.cloud.google.com/).
2. Create a new project or select an existing one.
3. Enable the **Places API** (New) for your project.
4. Generate an **API Key**.
5. (Optional but Recommended) Restrict your API key to your specific bundle ID (iOS) and package name (Android).

## USAGE

### Step 1: Initialize Google Places SDK

Call `initialize` once when your app starts.

Example (TypeScript / JavaScript):

```tsx
import { initialize } from 'react-native-google-places-turbo';

initialize(
  'YOUR_GOOGLE_PLACES_API_KEY',
  (message) => console.log('Google Places initialized:', message),
  (error) => console.error('Initialization error:', error)
);
```

### Step 2: Open Google Places Autocomplete Modal

```tsx
import { openAutocompleteModal } from 'react-native-google-places-turbo';

const handleSearch = async () => {
  try {
    const place = await openAutocompleteModal({
      countries: ['US', 'CA'],
    });
    console.log(place);
  } catch (error) {
    console.log('Autocomplete cancelled or failed', error);
  }
};
```

---

## API Reference

### Methods

#### `initialize(key, onSuccess?, onError?)`

Initializes the Native Google Places SDK.

| Parameter   | Type                    | Required | Description                            |
| :---------- | :---------------------- | :------- | :------------------------------------- |
| `key`       | `string`                | Yes      | Your Google Cloud API Key.             |
| `onSuccess` | `(msg: string) => void` | No       | Callback when initialization succeeds. |
| `onError`   | `(err: string) => void` | No       | Callback if initialization fails.      |

#### `openAutocompleteModal(options?)`

Opens the full-screen native place picker modal.

| Parameter | Type                  | Required | Description                       |
| :-------- | :-------------------- | :------- | :-------------------------------- |
| `options` | `AutocompleteOptions` | No       | Configuration object (see below). |

- **Returns**: `Promise<Place>`
- **Rejects**: If the user cancels the picker or an error occurs.

### Types

#### `AutocompleteOptions`

```ts
type AutocompleteOptions = {
  countries?: string[]; // Array of ISO 3166-1 Alpha-2 country codes (e.g. ["US", "IN"])
};
```

#### `Place`

The object returned when a user selects a location.

```ts
type Place = {
  name: string; // Name of the place (e.g., "Googleplex")
  placeID: string; // Unique Google Place ID
  coordinate: LatLng; // Geographic coordinates
  address: string; // Formatted address
};
```

#### `LatLng`

```ts
type LatLng = {
  latitude: number;
  longitude: number;
};
```

## Troubleshooting

- **Crash on Open**: Ensure you have enabled the "Places API" in Google Cloud Console, not just the Maps SDK.
- **Key Error**: Double check that your API Key has no restrictions that would block the current app's bundle ID / package name during development.
- **iOS Build Failure**: Make sure to run `pod install` inside the `ios` directory and open the `.xcworkspace` file, not `.xcodeproj`.

---

## COMPARISON WITH OTHER LIBRARIES

| Feature              | react-native-google-places-turbo |
| :------------------- | :-------------------------------- |
| **Native UI**        | ✅ Yes                            |
| **TurboModule**      | ✅ Yes                            |
| **New Architecture** | ✅ Yes                            |
| **Swift / Kotlin**   | ✅ Yes                            |
| **Bridge-free**      | ✅ Yes                            |

Most JavaScript-based Google Places libraries do not support these features.

---

## CONTRIBUTING

Contributions are welcome.
Please check [CONTRIBUTING.md](CONTRIBUTING.md) for development and contribution guidelines.

---

## LICENSE

MIT License

---

Built using [create-react-native-library](https://github.com/callstack/react-native-builder-bob) by Callstack
