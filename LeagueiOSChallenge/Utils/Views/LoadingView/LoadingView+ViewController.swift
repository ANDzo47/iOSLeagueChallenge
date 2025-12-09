//
//  LoadingView+ViewController.swift
//  LeagueiOSChallenge
//
//  Created by Andres Alejandro Rizzo on 08/12/2025.
//

import UIKit

protocol LoadingViewProtocol: AnyObject where Self: UIViewController {
    var loadingViewController: LoadingViewController? { get set }
    
    func showLoadingView()
    func hideLoadingView(onCompletion: (() -> Void)?)
}

// MARK: - Trait implementation
// Trait methods implementation in order to omit boilerplate in the
// app showing and hiding the loader
extension LoadingViewProtocol {
    func showLoadingView() {
        guard loadingViewController == nil,
              let rootViewController = UIApplication.shared.rootViewController else { return }
    
        let loadingViewController = LoadingViewController.loadingViewController()

        rootViewController.view.addSubview(loadingViewController.view)
        
        NSLayoutConstraint.activate([
            loadingViewController.view.topAnchor.constraint(equalTo: rootViewController.view.topAnchor),
            loadingViewController.view.leadingAnchor.constraint(equalTo: rootViewController.view.leadingAnchor),
            loadingViewController.view.trailingAnchor.constraint(equalTo: rootViewController.view.trailingAnchor),
            loadingViewController.view.bottomAnchor.constraint(equalTo: rootViewController.view.bottomAnchor)
        ])
        
        loadingViewController.view.alpha = 0.0
        UIView.animate(withDuration: 0.75, animations: {
            loadingViewController.view.alpha = 1.0
        })
        
        self.loadingViewController = loadingViewController
    }
    
    func hideLoadingView(onCompletion: (() -> Void)?) {
        guard let loadingViewController = loadingViewController else { return }
        
        UIView.animate(withDuration: 0.75, animations: {
            loadingViewController.view.alpha = 0.0
        }, completion: { [weak self] finished in
            loadingViewController.view.removeFromSuperview()
            self?.loadingViewController = nil
            onCompletion?()
        })
    }
}
