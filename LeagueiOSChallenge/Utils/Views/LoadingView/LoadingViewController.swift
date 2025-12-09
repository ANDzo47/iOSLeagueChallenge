//
//  LoadingViewController.swift
//
//  Created by Andres Rizzo on 27/8/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet weak var outerBorderedView: UIBorderedView!
    @IBOutlet weak var middleBorderedView: UIBorderedView!
    @IBOutlet weak var innerBorderedView: UIBorderedView!
    @IBOutlet weak var loadingImageView: UIImageView!
    
    struct Constants {
        static let loadingViewStoryboardIdentifier = "LoadingStoryboard"
    }
    
    var animating = true {
        didSet {
            self.animate()
        }
    }
    
    internal class func loadingViewController() -> LoadingViewController {
        
        let storyboard = UIStoryboard(name: Constants.loadingViewStoryboardIdentifier, bundle: Bundle.main)
        let loadingViewController = storyboard.instantiateInitialViewController() as! LoadingViewController
        
        return loadingViewController
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        animate()
        // Do any additional setup after loading the view.
    }

    private func animate() {
        
        rotateView(targetView: outerBorderedView, duration: 1.0)
        rotateView(targetView: middleBorderedView, duration: 1.0, angle: -3.14159265358979)
        rotateView(targetView: innerBorderedView, duration: 1.0)
        
    }
    
    private func rotateView(targetView: UIView, duration: Double = 1.0, angle: Double = 3.14159265358979) {
        
        if animating {
            UIView.animate(
                withDuration: duration,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
                    targetView.transform = CGAffineTransformRotate(targetView.transform, CGFloat(angle))
                },
                completion: { [weak self] finished in
                    self?.rotateView(targetView: targetView, duration: duration, angle: angle)
                }
            )
        }
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
