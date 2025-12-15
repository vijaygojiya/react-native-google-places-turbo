package com.googleplacesturbo

import android.app.Activity
import android.content.ActivityNotFoundException
import android.content.Context
import android.content.Intent
import com.facebook.react.bridge.ActivityEventListener
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.Callback
import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.module.annotations.ReactModule
import com.google.android.libraries.places.api.Places
import com.google.android.libraries.places.api.model.Place
import com.google.android.libraries.places.widget.Autocomplete
import com.google.android.libraries.places.widget.AutocompleteActivity
import com.google.android.libraries.places.widget.model.AutocompleteActivityMode

@ReactModule(name = GooglePlacesTurboModule.NAME)
class GooglePlacesTurboModule(reactContext: ReactApplicationContext) :
  NativeGooglePlacesTurboSpec(reactContext), ActivityEventListener {
  companion object {
    private const val AUTOCOMPLETE_REQUEST_CODE = 10101
    const val NAME = "GooglePlacesTurbo"
  }

  init {
    reactContext.addActivityEventListener(this)
  }

  private var isInitialized = false
  private var pendingPromise: Promise? = null

  override fun getName(): String {
    return NAME
  }


  override fun initialize(
    key: String?,
    onSuccess: Callback?,
    onError: Callback?
  ) {
    if (isInitialized) {
      onError?.invoke("Google Places SDK already initialized")
      return
    }

    if (key != null) {
      try {
        Places.initializeWithNewPlacesApiEnabled(reactApplicationContext.applicationContext, key)
        isInitialized = true
        onSuccess?.invoke("Google Places initialized")
      } catch (e: Exception) {
        onError?.invoke(e.message)
      }
    } else {
      onError?.invoke("Google Places API key is empty")
    }
  }

  override fun openAutocompleteModal(options: ReadableMap?, promise: Promise?) {
    if (!isInitialized) {
      promise?.reject("NOT_INITIALIZED", "Please call initialize() first")
      return
    }
    if (pendingPromise != null) {
      promise?.reject("IN_PROGRESS", "Place selection already in progress")
      return
    }
    val activity = reactApplicationContext.currentActivity
    if (activity == null) {
      promise?.reject("NO_ACTIVITY", "Current activity is null")
      return
    }

    pendingPromise = promise

    val fields = listOf(
      Place.Field.NAME,
      Place.Field.ID,
      Place.Field.ADDRESS,
      Place.Field.LAT_LNG
    )

    val builder = Autocomplete.IntentBuilder(
      AutocompleteActivityMode.OVERLAY,
      fields
    )

    if (options != null && options.hasKey("countries")) {
      val countriesArray = options.getArray("countries")
      val countriesList = ArrayList<String>()
      if (countriesArray != null) {
        for (i in 0 until countriesArray.size()) {
          countriesArray.getString(i)?.let {
            countriesList.add(it)
          }
        }
      }
      builder.setCountries(countriesList)
    }

    val intent = builder.build(activity)

    try {
      activity.startActivityForResult(intent, AUTOCOMPLETE_REQUEST_CODE)
    } catch (e: ActivityNotFoundException) {
      pendingPromise = null
      promise?.reject(e)
    }
  }


  override fun onActivityResult(
    activity: Activity,
    requestCode: Int,
    resultCode: Int,
    data: Intent?
  ) {
    if (requestCode != AUTOCOMPLETE_REQUEST_CODE) return

    val promise = pendingPromise ?: return
    pendingPromise = null

    when (resultCode) {
      Activity.RESULT_OK -> {
        val place = Autocomplete.getPlaceFromIntent(data!!)
        promise.resolve(parsePlace(place))
      }

      Activity.RESULT_CANCELED -> {
        promise.reject("CANCELLED", "User cancelled place selection")
      }

      AutocompleteActivity.RESULT_ERROR -> {
        val status = Autocomplete.getStatusFromIntent(data!!)
        promise.reject("ERROR", status.statusMessage)
      }
    }
  }

  override fun onNewIntent(intent: Intent) {}


  // =========================
  // Place Parser (Same as iOS)
  // =========================
  private fun parsePlace(place: Place): WritableMap {
    val map = Arguments.createMap()

    map.putString("name", place.name ?: "")
    map.putString("placeID", place.id ?: "")
    map.putString("address", place.address ?: "")

    val coordinate = Arguments.createMap()
    coordinate.putDouble("latitude", place.latLng?.latitude ?: 0.0)
    coordinate.putDouble("longitude", place.latLng?.longitude ?: 0.0)

    map.putMap("coordinate", coordinate)
    return map
  }


}
