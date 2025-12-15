import UIKit

func getTopViewController() -> UIViewController? {
    var controller = UIApplication.shared.connectedScenes
        .compactMap({ $0 as? UIWindowScene })
        .flatMap(\.windows)
        .first(where: { $0.isKeyWindow })?.rootViewController

    while let presentedViewController = controller?.presentedViewController {
        controller = presentedViewController
    }

    return controller
}
