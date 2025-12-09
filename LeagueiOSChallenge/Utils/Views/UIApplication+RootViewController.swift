//
//  UIApplication+RootViewController.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import UIKit

// Extension to get main window. Used on the loadingViewController
// trait method
extension UIApplication {
    var keyWindow: UIWindow? {
        return self.connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .first(where: { $0 is UIWindowScene })
            .flatMap({ $0 as? UIWindowScene })?.windows
            .first(where: \.isKeyWindow)
    }
    
    var rootViewController: UIViewController? {
        keyWindow?.rootViewController
    }
}
