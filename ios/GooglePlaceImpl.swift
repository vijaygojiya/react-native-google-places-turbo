import Foundation
import GooglePlaces
import React
import UIKit

@objcMembers
public class GooglePlaceImpl: NSObject {
  //  private var client: GMSPlacesClient? = nil

  private var placeSelectionCompletion: RCTPromiseResolveBlock?
  private var placeSelectionFailure: RCTPromiseRejectBlock?
  private var isInitialized = false

  public func initialize(
    _ apiKey: String,
    onSelect: @escaping RCTResponseSenderBlock,
    onError: RCTResponseSenderBlock
  ) {
    if isInitialized {
      onError(["Google Places SDK is already initialized"])
      return
    }
    guard !apiKey.isEmpty else {
      onError(["Google Places API key is empty"])
      return
    }
    DispatchQueue.main.async {
      GMSPlacesClient.provideAPIKey(apiKey)
      //    self.client = GMSPlacesClient.shared()
      self.isInitialized = true

      // Optional success callback
      onSelect(["GSMPlace: initialized"])
    }
  }

  // MARK: - Public API
  public func presentAutocompleteModal(
    options: [String: Any],
    resolve: @escaping RCTPromiseResolveBlock,
    reject: @escaping RCTPromiseRejectBlock
  ) {
    if !isInitialized {
      reject(
        "ERR_GOOGLE_PLACE",
        "Google Places SDK is not initialized,Please call initialize !",
        nil
      )
      return
    }
    // If modal already open → block new call
    guard placeSelectionCompletion == nil else {
      reject(
        "ERR_GOOGLE_PLACE",
        "Place selection already in progress",
        nil
      )
      return
    }

    self.placeSelectionCompletion = resolve
    self.placeSelectionFailure = reject

    guard let topVC = getTopViewController() else {
      fail("Unable to get top view controller")
      return
    }

    DispatchQueue.main.async {
      let controller = GMSAutocompleteViewController()
      controller.delegate = self
      controller.presentationController?.delegate = self

      controller.placeFields = [
        .name,
        .placeID,
        .formattedAddress,
        .coordinate,
      ]

      let filter = GMSAutocompleteFilter()

      if let countries = options["countries"] as? [String] {
        filter.countries = countries
      }

      controller.autocompleteFilter = filter

      topVC.present(controller, animated: true)
    }
  }

  // MARK: - Cleanup + Error helper
  private func fail(_ message: String) {
    placeSelectionFailure?("ERR_GOOGLE_PLACE", message, nil)
    cleanup()
  }

  private func succeed(_ dict: NSDictionary) {
    placeSelectionCompletion?(dict)
    cleanup()
  }

  private func cleanup() {
    placeSelectionCompletion = nil
    placeSelectionFailure = nil
  }
}

// MARK: - Google Places Delegate
extension GooglePlaceImpl: GMSAutocompleteViewControllerDelegate {

  public func viewController(
    _ viewController: GMSAutocompleteViewController,
    didAutocompleteWith place: GMSPlace
  ) {
    viewController.dismiss(animated: true) { [weak self] in
      guard let self = self else { return }
      let parsed = self.parsePlace(place)
      self.succeed(parsed)
    }
  }

  public func viewController(
    _ viewController: GMSAutocompleteViewController,
    didFailAutocompleteWithError error: any Error
  ) {
    viewController.dismiss(animated: true) { [weak self] in
      self?.fail("Error: \(error.localizedDescription)")
    }
  }

  public func wasCancelled(_ viewController: GMSAutocompleteViewController) {
    viewController.dismiss(animated: true) { [weak self] in
      self?.fail("User cancelled place selection")
    }
  }
}

// MARK: - Bottom-Sheet Swipe Down Dismiss
extension GooglePlaceImpl: UIAdaptivePresentationControllerDelegate {

  public func presentationControllerDidDismiss(
    _ presentationController: UIPresentationController
  ) {
    fail("User dismissed autocomplete")
  }
}

// MARK: - Place Parser (Clean)
extension GooglePlaceImpl {

  fileprivate func parsePlace(_ place: GMSPlace) -> NSDictionary {

    let coordinate = [
      "latitude": place.coordinate.latitude,
      "longitude": place.coordinate.longitude,
    ]

    return [
      "name": place.name ?? "",
      "placeID": place.placeID ?? "",
      "address": place.formattedAddress ?? "",
      "coordinate": coordinate,

    ]
  }
}
